{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    escapeShellArgs
    filter
    hasPrefix
    mapAttrsToList
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;
  format = pkgs.formats.toml { };
in
{
  options =
    let
      inherit (lib.types)
        bool
        enum
        lines
        listOf
        str
        ;
    in
    {
      services.yggdrasil-jumper = {
        enable = mkEnableOption "the Yggdrasil Jumper system service";

        retrieveListenAddresses = mkOption {
          type = bool;
          default = true;
          description = ''
            Automatically retrieve listen addresses from the Yggdrasil router configuration.

            See `yggdrasil_listen` option in Yggdrasil Jumper configuration.
          '';
        };

        appendListenAddresses = mkOption {
          type = bool;
          default = true;
          description = ''
            Append Yggdrasil router configuration with listeners on loopback
            addresses (`127.0.0.1`) and preselected ports to support peering
            using client-server protocols like `quic` and `tls`.

            See `Listen` option in Yggdrasil router configuration.
          '';
        };

        settings = mkOption {
          type = format.type;
          default = { };
          example = {
            listen_port = 9999;
            whitelist = [
              "<IPv6 address of a remote node>"
            ];
          };
          description = ''
            Configuration for Yggdrasil Jumper as a Nix attribute set.
          '';
        };

        extraConfig = mkOption {
          type = lines;
          default = "";
          example = ''
            listen_port = 9999;
            whitelist = [
              "<IPv6 address of a remote node>"
            ];
          '';
          description = ''
            Configuration for Yggdrasil Jumper in plaintext.
          '';
        };

        package = mkPackageOption pkgs "yggdrasil-jumper" { };

        logLevel = mkOption {
          type = enum [
            "off"
            "error"
            "warn"
            "info"
            "debug"
            "trace"
          ];
          default = "info";
          description = ''
            Set logging verbosity for Yggdrasil Jumper.
          '';
        };

        extraArgs = mkOption {
          type = listOf str;
          default = [ ];
          description = ''
            Extra command line arguments for Yggdrasil Jumper.
          '';
        };
      };
    };

  config =
    let
      cfg = config.services.yggdrasil-jumper;

      # Generate, concatenate and validate config file
      jumperSettings = format.generate "yggdrasil-jumper-settings" cfg.settings;
      jumperExtraConfig = pkgs.writeText "yggdrasil-jumper-extra-config" cfg.extraConfig;
      jumperConfig = pkgs.runCommand "yggdrasil-jumper-config" { } ''
        cat ${jumperSettings} ${jumperExtraConfig} \
          | tee $out \
          | ${cfg.package}/bin/yggdrasil-jumper --validate --config -
      '';
    in
    mkIf cfg.enable {
      assertions = [
        {
          assertion = config.services.yggdrasil.enable;
          message = "`services.yggdrasil.enable` must be true for `yggdrasil-jumper` to operate";
        }
      ];

      services.yggdrasil.settings.Listen =
        let
          # By default linux dynamically allocates ports in range 32768..60999
          # `sysctl net.ipv4.ip_local_port_range`
          # See: https://xkcd.com/221/
          prot_port = {
            "tls" = 11814;
            "quic" = 11814;
          };
        in
        mkIf (cfg.retrieveListenAddresses && cfg.appendListenAddresses) (
          mapAttrsToList (prot: port: "${prot}://127.0.0.1:${toString port}") prot_port
        );

      services.yggdrasil-jumper.settings = {
        yggdrasil_admin_listen = [ "unix:///run/yggdrasil/yggdrasil.sock" ];
        yggdrasil_listen = mkIf cfg.retrieveListenAddresses (
          filter (a: !hasPrefix "tcp://" a) config.services.yggdrasil.settings.Listen
        );
      };

      systemd.services.yggdrasil-jumper = {
        description = "Yggdrasil Jumper Service";
        after = [ "yggdrasil.service" ];
        unitConfig.BindsTo = [ "yggdrasil.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          User = "yggdrasil";
          DynamicUser = true;

          # TODO: Remove this delay after support for proper startup notification lands in `yggdrasil-go`
          ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
          ExecStart = escapeShellArgs (
            [
              "${cfg.package}/bin/yggdrasil-jumper"
              "--loglevel"
              "${cfg.logLevel}"
              "--config"
              "${jumperConfig}"
            ]
            ++ cfg.extraArgs
          );
          KillSignal = "SIGINT";

          MemoryDenyWriteExecute = true;
          ProtectControlGroups = true;
          ProtectHome = "tmpfs";
          RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
          ];
        };
      };

      environment.systemPackages = [ cfg.package ];
    };

  meta.maintainers = with lib.maintainers; [ one-d-wide ];
}
