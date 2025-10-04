{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkOption;
  inherit (lib.types)
    nullOr
    path
    bool
    listOf
    str
    int
    attrs
    attrsOf
    submodule
    ;
  cfg = config.services.yggdrasil;

  # Build base configuration with systemd credential path override
  baseSettings =
    cfg.settings
    // (
      if cfg.settings.PrivateKeyPath != null then
        {
          PrivateKeyPath = "/private-key";
        }
      else
        { }
    );

  # Remove null values that yggdrasil doesn't expect
  cleanSettings = lib.filterAttrs (n: v: v != null) baseSettings;

  # Generate configuration file from user settings
  configFile = pkgs.writeTextFile {
    name = "yggdrasil.conf";
    text = builtins.toJSON cleanSettings;
  };
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "yggdrasil" "config" ]
      [ "services" "yggdrasil" "settings" ]
    )
  ];

  options = {
    services.yggdrasil = {
      enable = lib.mkEnableOption "the yggdrasil system service";

      settings = mkOption {
        type = submodule {
          freeformType = attrs;
          options = {
            PrivateKeyPath = mkOption {
              type = nullOr path;
              default = null;
              example = "/run/secrets/yggdrasil-private-key";
              description = ''
                Path to the private key file on the host system.
                When specified, the key will be loaded via systemd credentials
                for secure access by the yggdrasil service.

                Warning: Do not put private keys directly in the Nix store
                as they would be world-readable!
              '';
            };

            Peers = mkOption {
              type = listOf str;
              default = [ ];
              example = [
                "tcp://aa.bb.cc.dd:eeeee"
                "tcp://[aaaa:bbbb:cccc:dddd::eeee]:fffff"
              ];
              description = ''
                List of outbound peer connection strings.
                Connection strings can contain options, see the yggdrasil documentation.
              '';
            };

            Listen = mkOption {
              type = listOf str;
              default = [ ];
              example = [
                "tcp://0.0.0.0:xxxxx"
                "tls://[::]:yyyyy"
              ];
              description = ''
                Listen addresses for incoming connections.
                You need listeners to accept incoming peerings from non-local nodes.
              '';
            };

            AllowedPublicKeys = mkOption {
              type = listOf str;
              default = [ ];
              description = ''
                List of peer public keys to allow incoming peering connections from.
                If left empty, all connections are allowed by default.
              '';
            };
          };
        };
        default = { };
        example = {
          Peers = [
            "tcp://aa.bb.cc.dd:eeeee"
            "tcp://[aaaa:bbbb:cccc:dddd::eeee]:fffff"
          ];
          Listen = [
            "tcp://0.0.0.0:xxxxx"
          ];
          PrivateKeyPath = "/run/secrets/yggdrasil-key";
          IfName = "ygg0";
          IfMTU = 65535;
        };
        description = ''
          Configuration for yggdrasil, as a structured Nix attribute set.

          If you specify settings here, they will be used as persistent
          configuration and Yggdrasil will retain the same configuration
          (including IPv6 address if keys are provided) across restarts.

          If no settings are specified, ephemeral keys are generated
          and the Yggdrasil interface will have a random IPv6 address
          each time the service is started.

          Use {option}`settings.PrivateKeyPath` to securely load private
          keys from files owned by root via systemd credentials.

          The most important options have dedicated NixOS options above.
          You can also specify any other yggdrasil configuration option directly.

          For a complete list of available options, see:
          https://yggdrasil-network.github.io/configurationref.html

          You can use the command `nix-shell -p yggdrasil --run "yggdrasil -genconf"`
          to generate default configuration values with documentation.
        '';
      };

      group = mkOption {
        type = nullOr str;
        default = null;
        example = "wheel";
        description = "Group to grant access to the Yggdrasil control socket. If `null`, only root can access the socket.";
      };

      openMulticastPort = mkOption {
        type = bool;
        default = false;
        description = ''
          Whether to open the UDP port used for multicast peer discovery. The
          NixOS firewall blocks link-local communication, so in order to make
          incoming local peering work you will also need to configure
          `MulticastInterfaces` in your Yggdrasil configuration
          ({option}`settings`). You will then have to
          add the ports that you configure there to your firewall configuration
          ({option}`networking.firewall.allowedTCPPorts` or
          {option}`networking.firewall.interfaces.<name>.allowedTCPPorts`).
        '';
      };

      denyDhcpcdInterfaces = mkOption {
        type = listOf str;
        default = [ ];
        example = [ "tap*" ];
        description = ''
          Disable the DHCP client for any interface whose name matches
          any of the shell glob patterns in this list.  Use this
          option to prevent the DHCP client from broadcasting requests
          on the yggdrasil network.  It is only necessary to do so
          when yggdrasil is running in TAP mode, because TUN
          interfaces do not support broadcasting.
        '';
      };

      package = lib.mkPackageOption pkgs "yggdrasil" { };

      extraArgs = mkOption {
        type = listOf str;
        default = [ ];
        example = [
          "-loglevel"
          "info"
        ];
        description = "Extra command line arguments.";
      };

    };
  };

  config = mkIf cfg.enable (
    let
      binYggdrasil = "${cfg.package}/bin/yggdrasil";
    in
    {
      assertions = [
        {
          assertion = config.networking.enableIPv6;
          message = "networking.enableIPv6 must be true for yggdrasil to work";
        }
        {
          assertion = !(cfg.settings ? PrivateKey);
          message = ''
            services.yggdrasil.settings.PrivateKey is not supported because it
            would be stored in the world-readable Nix store.
            Use services.yggdrasil.settings.PrivateKeyPath instead to securely load the private key from a file.
          '';
        }
      ];

      systemd.services.yggdrasil = {
        description = "Yggdrasil Network Service";
        after = [ "network-pre.target" ];
        wants = [ "network.target" ];
        before = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        script =
          if cfg.settings != { } then
            # Use user settings (persistent configuration)
            "exec ${binYggdrasil} -useconffile ${configFile} ${lib.strings.escapeShellArgs cfg.extraArgs}"
          else
            # Generate and use ephemeral config
            "exec ${binYggdrasil} -genconf | ${binYggdrasil} -useconf ${lib.strings.escapeShellArgs cfg.extraArgs}";

        serviceConfig = {
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          Restart = "always";

          DynamicUser = true;
          StateDirectory = "yggdrasil";
          RuntimeDirectory = "yggdrasil";
          RuntimeDirectoryMode = "0750";
          BindReadOnlyPaths = lib.optional (
            cfg.settings.PrivateKeyPath != null
          ) "%d/private-key:/private-key";
          LoadCredential = lib.optional (
            cfg.settings.PrivateKeyPath != null
          ) "private-key:${cfg.settings.PrivateKeyPath}";

          AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE";
          CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE";
          MemoryDenyWriteExecute = true;
          ProtectControlGroups = true;
          ProtectHome = "tmpfs";
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged @keyring"
          ];
        }
        // (
          if (cfg.group != null) then
            {
              Group = cfg.group;
            }
          else
            { }
        );
      };

      networking.dhcpcd.denyInterfaces = cfg.denyDhcpcdInterfaces;
      networking.firewall.allowedUDPPorts = mkIf cfg.openMulticastPort [ 9001 ];

      # Make yggdrasilctl available on the command line.
      environment.systemPackages = [ cfg.package ];
    }
  );
  meta = {
    doc = ./yggdrasil.md;
    maintainers = with lib.maintainers; [
      gazally
      nagy
      pinpox
    ];
  };
}
