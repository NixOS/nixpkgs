{ options, config, pkgs, lib, ... }:
let
  inherit (lib) mkOption types mdDoc;
in
{
  options.socketActivation = mkOption {
    type = types.attrsOf (types.submodule ({ name, ... }: {
      options = {
        enable = lib.mkEnableOption "socket activation for a systemd service";

        service = mkOption {
          type = types.str;
          default = name;
          defaultText = "<name>";
          example = "gitea";
          description = mdDoc "Systemd service name";
        };

        privateNamespace = mkOption {
          type = types.bool;
          default = true;
          example = false;
          description = mdDoc ''
            Whether to isolate the network of the original service.

            This is recommended, but might be impractical if the original
            service also uses networking for its own operation.
          '';
        };

        originalSocketAddress = mkOption {
          type = types.str;
          example = "localhost:8080";
          description = mdDoc ''
            Socket that the original service is listening to.

            This could be an INET/6 or UNIX socket.
          '';
        };

        newSocketAddress = mkOption {
          type = with types; either str port;
          default = "/run/${name}.socket";
          defaultText = "/run/<name>.socket";
          example = "localhost:8080";
          description = mdDoc ''
            Address of the new systemd socket.

            This could be an INET/6 or UNIX socket.
          '';
        };

        connectionsMax = mkOption {
          type = types.ints.unsigned;
          default = 256;
          example = 1024;
          description = mdDoc ''
            Sets the maximum number of simultaneous connections.
            If the limit of concurrent connections is reached further connections will be refused.

            See <https://www.freedesktop.org/software/systemd/man/systemd-socket-proxyd.html#--connections-max=>
          '';
        };

        exitIdleTime = mkOption {
          type = types.nullOr types.str;
          default = "5m";
          example = "1h";
          description = mdDoc ''
            Amount of inactivity time, before systemd shuts down the service.
            If this is set to `null`, the service will never stop.

            See <https://www.freedesktop.org/software/systemd/man/systemd-socket-proxyd.html#--exit-idle-time=>
          '';
        };

        openFirewall = mkOption {
          type = types.bool;
          default = false;
          example = true;
          description = mdDoc ''
            Whether to open the firewall for {var}`newSocketAddress`
          '';
        };

        createNginxUpstream = mkOption {
          type = types.bool;
          default = true;
          example = false;
          description = mdDoc ''
            Whether to create an http upstream entry for {var}`newSocketAddress` in nginx.

            See <https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream>
          '';
        };

        extraSocketConfig = mkOption {
          type = types.attrs; # TODO: not exactly sure how to type this,
                              #       maybe reexposing this through the module is a bad idea?
          default = { };
          example = {
            KeepAlive = true;
            MaxConnectionsPerSource = 3;
            Priority = 2;
          };
          description = mdDoc ''
            Extra configuration to go into the [socket] section of the systemd unit.

            See <https://www.freedesktop.org/software/systemd/man/latest/systemd.socket.html>
          '';
        };
      };
    }));
    description = mdDoc "Socket activated services using {command}`systemd-socket-proxyd`.";
    default = { };
  };

  config = let
    activeServices = lib.filterAttrs (_: value: value.enable) config.socketActivation;
    foreachService = f: lib.mapAttrsToList f activeServices;
  in {
    assertions = foreachService (name: value: {
      # NOTE: This assertion is just covering for the most basic invalid usecases, but misses a lot.
      #       The original socket address could've been "localhost:1234" and now only "1234",
      #         while still meaning the same thing.
      assertion = lib.any (b: b) [
        value.privateNamespace
        # If this is a UNIX socket, the paths themself
        # would clash even if in a private namespace
        (lib.hasPrefix "/" value.originalSocketAddress)
        (lib.hasPrefix "@" value.originalSocketAddress)
      ] -> (value.originalSocketAddress != value.newSocketAddress);
      message = ''
        The new proxied socket of "${name}" has a new socket address of "${toString value.newSocketAddress}",
        which clashes with its original address of "${toString value.originalSocketAddress}".

        Either enable privateNamespace to isolate the original service' network, or use a separate socket address.
      '';
    });

    services.nginx.upstreams = let
      servicesWithNginxUpstream = lib.filterAttrs (_: value: value.createNginxUpstream) activeServices;
    in lib.mapAttrsToList (name: value: let
      protocol = if lib.any (p: lib.hasPrefix p value.newSocketAddress) [ "/" "@" ]  then "unix" else "http";
    in {
      ${name}.servers."${protocol}:${value.newSocketAddress}" = { };
    }) servicesWithNginxUpstream;

    systemd = lib.mkMerge (foreachService (name: value: let
      originalService = config.systemd.services.${value.service};
    in {
      sockets."${name}-proxy" = {
        wantedBy = [ "sockets.target" ];
        socketConfig = {
          ListenStream = value.newSocketAddress;
          MaxConnections = value.connectionsMax;
        };
      };

      services."${name}-proxy" = rec {
        requires = [
          "${name}.service"
          "${name}-proxy.socket"
        ];
        after = requires;

        unitConfig.JoinsNamespaceOf = lib.mkIf value.privateNamespace "${value.service}.service";

        serviceConfig = {
          ExecStart = let
            args = lib.cli.toGNUCommandLineShell { } {
              exit-idle-time = if value.exitIdleTime != null then value.exitIdleTime else "infinity";
              connections-max = value.connectionsMax;
            };
          in ''${pkgs.systemd}/lib/systemd/systemd-socket-proxyd ${args} "${value.originalSocketAddress}"'';
          PrivateNetwork = value.privateNamespace;
        };
      };

      services.${name} = {
        unitConfig.StopWhenUnneeded = true;
        serviceConfig.PrivateNetwork = value.privateNamespace;
      };
    }));
  };

  meta.maintainers = with lib.maintainers; [ h7x4 ];
}
