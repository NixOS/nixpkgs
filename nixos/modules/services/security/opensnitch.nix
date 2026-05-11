{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.opensnitch;
  format = pkgs.formats.json { };

  predefinedRules = lib.flip lib.mapAttrs cfg.rules (
    name: cfg: {
      file = pkgs.writeText "rule" (builtins.toJSON cfg);
    }
  );
in
{
  options = {
    services.opensnitch = {
      enable = lib.mkEnableOption "Opensnitch application firewall";
      package = lib.mkPackageOption pkgs "opensnitch" { };

      rules = lib.mkOption {
        default = { };
        example = lib.literalExpression ''
          {
            "tor" = {
              "name" = "tor";
              "enabled" = true;
              "action" = "allow";
              "duration" = "always";
              "operator" = {
                "type" ="simple";
                "sensitive" = false;
                "operand" = "process.path";
                "data" = "''${lib.getBin pkgs.tor}/bin/tor";
              };
            };
          };
        '';

        description = ''
          Declarative configuration of firewall rules.
          All rules will be stored in `/var/lib/opensnitch/rules` by default.
          Rules path can be configured with `settings.Rules.Path`.
          See [upstream documentation](https://github.com/evilsocket/opensnitch/wiki/Rules)
          for available options.
        '';

        type = lib.types.submodule {
          freeformType = format.type;
        };
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = format.type;

          options = {
            Server = {

              Address = lib.mkOption {
                type = lib.types.str;
                description = ''
                  Unix socket path (unix:///tmp/osui.sock, the "unix:///" part is
                  mandatory) or TCP socket (192.168.1.100:50051).
                '';
              };

              LogFile = lib.mkOption {
                type = lib.types.path;
                description = ''
                  File to write logs to (use /dev/stdout to write logs to standard
                  output).
                '';
              };

            };

            DefaultAction = lib.mkOption {
              type = lib.types.enum [
                "allow"
                "deny"
              ];
              description = ''
                Default action whether to block or allow application internet
                access.
              '';
            };

            InterceptUnknown = lib.mkOption {
              type = lib.types.bool;
              description = ''
                Whether to intercept spare connections.
              '';
            };

            ProcMonitorMethod = lib.mkOption {
              type = lib.types.enum [
                "ebpf"
                "proc"
                "ftrace"
                "audit"
              ];
              description = ''
                Which process monitoring method to use.
              '';
            };

            LogLevel = lib.mkOption {
              type = lib.types.ints.between 0 4;
              description = ''
                Default log level from 0 to 4 (debug, info, important, warning,
                error).
              '';
            };

            Firewall = lib.mkOption {
              type = lib.types.enum [
                "iptables"
                "nftables"
              ];
              description = ''
                Which firewall backend to use.
              '';
            };

            Stats = {

              MaxEvents = lib.mkOption {
                type = lib.types.int;
                description = ''
                  Max events to send to the GUI.
                '';
              };

              MaxStats = lib.mkOption {
                type = lib.types.int;
                description = ''
                  Max stats per item to keep in backlog.
                '';
              };

            };

            Ebpf.ModulesPath = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
              default =
                if cfg.settings.ProcMonitorMethod == "ebpf" then
                  "${config.boot.kernelPackages.opensnitch-ebpf}/etc/opensnitchd"
                else
                  null;
              defaultText = lib.literalExpression ''
                if cfg.settings.ProcMonitorMethod == "ebpf" then
                  "\\$\\{config.boot.kernelPackages.opensnitch-ebpf\\}/etc/opensnitchd"
                else null;
              '';
              description = ''
                Configure eBPF modules path. Used when
                `settings.ProcMonitorMethod` is set to `ebpf`.
              '';
            };

            Audit.AudispSocketPath = lib.mkOption {
              type = lib.types.path;
              default = "/run/audit/audispd_events";
              description = ''
                Configure audit socket path. Used when
                `settings.ProcMonitorMethod` is set to `audit`.
              '';
            };

            Rules.Path = lib.mkOption {
              type = lib.types.path;
              default = "/var/lib/opensnitch/rules";
              description = ''
                Path to the directory where firewall rules can be found and will
                get stored by the NixOS module.
              '';
            };

          };
        };
        description = ''
          opensnitchd configuration. Refer to [upstream documentation](https://github.com/evilsocket/opensnitch/wiki/Configurations)
          for details on supported values.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    # pkg.opensnitch is referred to elsewhere in the module so we don't need to worry about it being garbage collected
    services.opensnitch.settings = lib.mapAttrs (_: v: lib.mkDefault v) (
      builtins.fromJSON (
        builtins.unsafeDiscardStringContext (
          builtins.readFile "${cfg.package}/etc/opensnitchd/default-config.json"
        )
      )
    );

    security.auditd = lib.mkIf (cfg.settings.ProcMonitorMethod == "audit") {
      enable = true;
      plugins.af_unix.active = true;
    };

    systemd = {
      packages = [ cfg.package ];
      services.opensnitchd = {
        wantedBy = [ "multi-user.target" ];
        path = lib.optionals (cfg.settings.ProcMonitorMethod == "audit") [ pkgs.audit ];
        serviceConfig = {
          ExecStart =
            let
              preparedSettings = removeAttrs cfg.settings (
                lib.optional (cfg.settings.ProcMonitorMethod != "ebpf") "Ebpf"
              );
            in
            [
              ""
              "${lib.getExe' cfg.package "opensnitchd"} --config-file ${format.generate "default-config.json" preparedSettings}"
            ];
        };
        preStart = lib.mkIf (cfg.rules != { }) (
          let
            rules = lib.flip lib.mapAttrsToList predefinedRules (
              file: content: {
                inherit (content) file;
                local = "${cfg.settings.Rules.Path}/${file}.json";
              }
            );
          in
          ''
            # Remove all firewall rules from rules path (configured with
            # cfg.settings.Rules.Path) that are symlinks to a store-path, but aren't
            # declared in `cfg.rules` (i.e. all networks that were "removed" from
            # `cfg.rules`).
            find ${cfg.settings.Rules.Path} -type l -lname '${builtins.storeDir}/*' ${
              lib.optionalString (rules != { }) ''
                -not \( ${
                  lib.concatMapStringsSep " -o " ({ local, ... }: "-name '${baseNameOf local}*'") rules
                } \) \
              ''
            } -delete
            ${lib.concatMapStrings (
              { file, local }:
              ''
                ln -sf '${file}' "${local}"
              ''
            ) rules}
          ''
        );
      };
      tmpfiles.rules = [
        "d ${cfg.settings.Rules.Path} 0750 root root - -"
        "L+ /etc/opensnitchd/system-fw.json - - - - ${cfg.package}/etc/opensnitchd/system-fw.json"
      ];
    };

  };

  meta.maintainers = with lib.maintainers; [
    onny
    grimmauld
  ];
}
