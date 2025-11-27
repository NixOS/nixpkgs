{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.tailscale.service;

  # Parse endpoint key into components
  # Format: "protocol:port" or "protocol:port:path"
  # Examples: "https:443", "http:80", "tcp:5432", "https:443:/api"
  parseEndpoint =
    endpointKey:
    let
      parts = splitString ":" endpointKey;
      protocol = elemAt parts 0;
      port = elemAt parts 1;
      path = if length parts > 2 then concatStringsSep ":" (drop 2 parts) else null;
    in
    {
      inherit protocol port path;
    };

  # Generate tailscale serve command for an endpoint
  mkServeCommand =
    serviceName: endpointKey: target:
    let
      endpoint = parseEndpoint endpointKey;
      protocolFlag =
        if endpoint.protocol == "https" then
          "--https"
        else if endpoint.protocol == "http" then
          "--http"
        else if endpoint.protocol == "tcp" then
          "--tcp"
        else if endpoint.protocol == "tls-terminated-tcp" then
          "--tls-terminated-tcp"
        else
          throw "Unsupported protocol: ${endpoint.protocol}";
      pathFlag = optionalString (endpoint.path != null) "--set-path ${endpoint.path}";
    in
    "${protocolFlag}=${endpoint.port} ${pathFlag} ${target}";

  # Generate the configuration script for a service
  mkServiceScript =
    serviceName: serviceCfg:
    let
      tailscaleBin = "${config.services.tailscale.package}/bin/tailscale";

      # Generate serve commands for each endpoint
      serveCommands = mapAttrsToList (
        endpointKey: target:
        let
          cmd = mkServeCommand serviceName endpointKey target;
        in
        "${tailscaleBin} serve --service=svc:${serviceName} ${cmd}"
      ) serviceCfg.endpoints;

      # Add TUN mode if enabled
      tunCommand = optionalString serviceCfg.tun "${tailscaleBin} serve --service=svc:${serviceName} --tun";

      # Advertise the service
      advertiseCommand = "${tailscaleBin} serve advertise svc:${serviceName}";

      allCommands = serveCommands ++ optional serviceCfg.tun tunCommand ++ [ advertiseCommand ];
    in
    pkgs.writeShellScript "tailscale-service-${serviceName}" ''
      set -e

      # Wait for tailscaled to be ready
      echo "Waiting for tailscaled to be ready..."
      for i in {1..30}; do
        if ${tailscaleBin} status --json >/dev/null 2>&1; then
          STATE=$(${tailscaleBin} status --json | ${pkgs.jq}/bin/jq -r '.BackendState')
          if [ "$STATE" = "Running" ]; then
            echo "Tailscaled is ready."
            break
          fi
        fi
        if [ $i -eq 30 ]; then
          echo "Timeout waiting for tailscaled to be ready."
          exit 1
        fi
        sleep 1
      done

      # Function to run a command with retry on etag conflicts
      run_with_retry() {
        local max_attempts=10
        local attempt=1
        local base_delay=1

        while [ $attempt -le $max_attempts ]; do
          if output=$(eval "$@" 2>&1); then
            echo "$output"
            return 0
          else
            # Check if it's an etag/concurrent modification error
            if echo "$output" | grep -q -E "(etag mismatch|Another client is changing|Preconditions failed)"; then
              if [ $attempt -eq $max_attempts ]; then
                echo "Failed after $max_attempts attempts due to concurrent modifications" >&2
                echo "$output" >&2
                return 1
              fi

              # Exponential backoff with jitter
              local delay=$((base_delay * attempt + RANDOM % 3))
              echo "Concurrent modification detected, retrying in ''${delay}s (attempt $attempt/$max_attempts)..." >&2
              sleep $delay
              attempt=$((attempt + 1))
            else
              # Different error, don't retry
              echo "$output" >&2
              return 1
            fi
          fi
        done
      }

      # Execute commands with retry logic
      ${concatStringsSep "\n" (map (cmd: "run_with_retry ${cmd}") allCommands)}
    '';

  # Generate the cleanup script for stopping a service
  mkCleanupScript =
    serviceName: serviceCfg:
    let
      tailscaleBin = "${config.services.tailscale.package}/bin/tailscale";
    in
    pkgs.writeShellScript "tailscale-service-${serviceName}-cleanup" ''
      set -e

      # Drain the service (stops accepting new connections)
      echo "Draining service svc:${serviceName}..."
      ${tailscaleBin} serve drain svc:${serviceName} || true

      # Wait for connections to close gracefully
      echo "Waiting for connections to close..."
      sleep ${toString serviceCfg.drainTimeout}

      # Remove all endpoint configurations for this service
      echo "Clearing service configuration..."
      ${tailscaleBin} serve clear svc:${serviceName} || true

      echo "Service svc:${serviceName} stopped and cleaned up."
    '';

  # Create systemd service for each enabled Tailscale Service
  mkSystemdService =
    serviceName: serviceCfg:
    nameValuePair "tailscale-service-${serviceName}" {
      description = "Tailscale Service: ${serviceName}";
      after = [ "tailscaled.service" ];
      requires = [ "tailscaled.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = mkServiceScript serviceName serviceCfg;
        ExecStop = mkCleanupScript serviceName serviceCfg;
        # Ensure we have time to drain connections
        TimeoutStopSec = serviceCfg.drainTimeout + 10;
      };
    };

  # Filter enabled services
  enabledServices = filterAttrs (_: serviceCfg: serviceCfg.enable) cfg;
in
{
  meta.maintainers = with maintainers; [
    kusold
  ];

  options = {
    services.tailscale.service = mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              enable = mkEnableOption "Tailscale Service ${name}";

              endpoints = mkOption {
                type = types.attrsOf types.str;
                default = { };
                description = ''
                  Endpoint mappings for the Tailscale Service.

                  Format: "protocol:port[:path]" = "target"

                  Supported protocols:
                  - https: Layer 7 HTTPS endpoint
                  - http: Layer 7 HTTP endpoint
                  - tcp: Layer 4 TCP endpoint
                  - tls-terminated-tcp: Layer 4 TLS-terminated TCP endpoint

                  Examples:
                  - "https:443" = "http://localhost:8080"
                  - "http:80" = "http://localhost:3000"
                  - "tcp:5432" = "tcp://localhost:5432"
                  - "https:443:/api" = "http://localhost:8081"
                '';
                example = {
                  "https:443" = "http://localhost:8080";
                  "http:80" = "http://localhost:8080";
                  "tcp:5432" = "tcp://localhost:5432";
                };
              };

              tun = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Enable Layer 3 (TUN) mode for this service.
                  This creates a protocol-agnostic endpoint that forwards all traffic
                  to the local device without modification.

                  Only works on Linux and requires additional OS configuration.
                '';
              };

              drainTimeout = mkOption {
                type = types.int;
                default = 5;
                description = ''
                  Time in seconds to wait after draining the service for connections
                  to close gracefully before clearing the configuration.
                '';
              };
            };
          }
        )
      );
      default = { };
      description = ''
        Tailscale Services configuration.

        Each attribute defines a Tailscale Service that will be advertised
        from this host. The service must already be defined in your tailnet
        through the Tailscale admin console.

        This host must use a tag-based identity to act as a service host.
      '';
      example = {
        web-server = {
          enable = true;
          endpoints = {
            "https:443" = "http://localhost:8080";
            "http:80" = "http://localhost:8080";
          };
        };
        database = {
          enable = true;
          endpoints = {
            "tcp:5432" = "tcp://localhost:5432";
          };
        };
      };
    };
  };

  config = mkIf (enabledServices != { }) {
    # Assert that Tailscale is enabled
    assertions = [
      {
        assertion = config.services.tailscale.enable;
        message = ''
          Tailscale Services requires services.tailscale.enable = true.
          Please enable the base Tailscale service before configuring Tailscale Services.
        '';
      }
    ];

    # Create systemd services for each enabled Tailscale Service
    systemd.services = listToAttrs (mapAttrsToList mkSystemdService enabledServices);
  };
}
