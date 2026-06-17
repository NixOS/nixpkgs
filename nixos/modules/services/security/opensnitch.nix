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

      upstreamDefaults = lib.mkOption {
        description = ''
          Whether to base the config declared in {option}`services.opensnitch.settings` on the upstream example config (<https://github.com/evilsocket/opensnitch/blob/master/daemon/data/default-config.json>)

          Disable this if you want to declare your opensnitch config from scratch.
        '';
        type = lib.types.bool;
        default = true;
      };

      configFile = lib.mkOption {
        description = ''
          Path to JSON config file. See: <https://github.com/evilsocket/opensnitch/blob/master/daemon/data/default-config.json>
          If this option is set, it will override any configuration done in options.services.opensnitch.settings.
        '';
        example = "/etc/opensnitchd/default-config.json";
        type = lib.types.path;
        default =
          let
            generatedConfig = format.generate "config.json" cfg.settings;
          in
          if cfg.upstreamDefaults then
            pkgs.runCommand "opensnitch-config.json" { } ''
              ${lib.getExe pkgs.jq} -s '.[0] * .[1]' ${cfg.package}/etc/opensnitchd/default-config.json ${format.generate "config.json" cfg.settings} >"$out"
            ''
          else
            generatedConfig;
        defaultText = lib.literalMD "JSON file generated from {option}`services.opensnitch.settings`";
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = format.type;

          options = {
            ProcMonitorMethod = lib.mkOption {
              type = lib.types.enum [
                "ebpf"
                "proc"
                "ftrace"
                "audit"
              ];
              default = "ebpf";
              description = ''
                Which process monitoring method to use.
              '';
            };

            Firewall = lib.mkOption {
              type = lib.types.enum [
                "iptables"
                "nftables"
              ];
              default = if config.networking.nftables.enable then "nftables" else "iptables";
              defaultText = lib.literalExpression ''if config.networking.nftables.enable then "nftables" else "iptables"'';
              description = ''
                Which firewall backend to use.
              '';
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
                  "''${config.boot.kernelPackages.opensnitch-ebpf}/etc/opensnitchd"
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
          ExecStart = [
            ""
            "${lib.getExe' cfg.package "opensnitchd"} --config-file ${cfg.configFile}"
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
