{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.opensnitch;
  format = pkgs.formats.json {};

  predefinedRules = flip mapAttrs cfg.rules (name: cfg: {
    file = pkgs.writeText "rule" (builtins.toJSON cfg);
  });

in {
  options = {
    services.opensnitch = {
      enable = mkEnableOption (mdDoc "Opensnitch application firewall");

      rules = mkOption {
        default = {};
        example = literalExpression ''
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

        description = mdDoc ''
          Declarative configuration of firewall rules.
          All rules will be stored in `/var/lib/opensnitch/rules` by default.
          Rules path can be configured with `settings.Rules.Path`.
          See [upstream documentation](https://github.com/evilsocket/opensnitch/wiki/Rules)
          for available options.
        '';

        type = types.submodule {
          freeformType = format.type;
        };
      };

      settings = mkOption {
        type = types.submodule {
          freeformType = format.type;

          options = {
            Server = {

              Address = mkOption {
                type = types.str;
                description = mdDoc ''
                  Unix socket path (unix:///tmp/osui.sock, the "unix:///" part is
                  mandatory) or TCP socket (192.168.1.100:50051).
                '';
              };

              LogFile = mkOption {
                type = types.path;
                description = mdDoc ''
                  File to write logs to (use /dev/stdout to write logs to standard
                  output).
                '';
              };

            };

            DefaultAction = mkOption {
              type = types.enum [ "allow" "deny" ];
              description = mdDoc ''
                Default action whether to block or allow application internet
                access.
              '';
            };

            InterceptUnknown = mkOption {
              type = types.bool;
              description = mdDoc ''
                Whether to intercept spare connections.
              '';
            };

            ProcMonitorMethod = mkOption {
              type = types.enum [ "ebpf" "proc" "ftrace" "audit" ];
              description = mdDoc ''
                Which process monitoring method to use.
              '';
            };

            LogLevel = mkOption {
              type = types.enum [ 0 1 2 3 4 ];
              description = mdDoc ''
                Default log level from 0 to 4 (debug, info, important, warning,
                error).
              '';
            };

            Firewall = mkOption {
              type = types.enum [ "iptables" "nftables" ];
              description = mdDoc ''
                Which firewall backend to use.
              '';
            };

            Stats = {

              MaxEvents = mkOption {
                type = types.int;
                description = mdDoc ''
                  Max events to send to the GUI.
                '';
              };

              MaxStats = mkOption {
                type = types.int;
                description = mdDoc ''
                  Max stats per item to keep in backlog.
                '';
              };

            };

            Ebpf.ModulesPath = mkOption {
              type = types.path;
              default = if cfg.settings.ProcMonitorMethod == "ebpf" then "${config.boot.kernelPackages.opensnitch-ebpf}/etc/opensnitchd" else null;
              defaultText = literalExpression ''
                if cfg.settings.ProcMonitorMethod == "ebpf" then
                  "\\$\\{config.boot.kernelPackages.opensnitch-ebpf\\}/etc/opensnitchd"
                else null;
              '';
              description = mdDoc ''
                Configure eBPF modules path. Used when
                `settings.ProcMonitorMethod` is set to `ebpf`.
              '';
            };

            Rules.Path = mkOption {
              type = types.path;
              default = "/var/lib/opensnitch/rules";
              description = mdDoc ''
                Path to the directory where firewall rules can be found and will
                get stored by the NixOS module.
              '';
            };

          };
        };
        description = mdDoc ''
          opensnitchd configuration. Refer to [upstream documentation](https://github.com/evilsocket/opensnitch/wiki/Configurations)
          for details on supported values.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    # pkg.opensnitch is referred to elsewhere in the module so we don't need to worry about it being garbage collected
    services.opensnitch.settings = mapAttrs (_: v: mkDefault v) (builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile "${pkgs.opensnitch}/etc/opensnitchd/default-config.json")));

    systemd = {
      packages = [ pkgs.opensnitch ];
      services.opensnitchd = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = [
            ""
            "${pkgs.opensnitch}/bin/opensnitchd --config-file ${format.generate "default-config.json" cfg.settings}"
          ];
        };
        preStart = mkIf (cfg.rules != {}) (let
          rules = flip mapAttrsToList predefinedRules (file: content: {
          inherit (content) file;
          local = "${cfg.settings.Rules.Path}/${file}.json";
        });
        in ''
          # Remove all firewall rules from rules path (configured with
          # cfg.settings.Rules.Path) that are symlinks to a store-path, but aren't
          # declared in `cfg.rules` (i.e. all networks that were "removed" from
          # `cfg.rules`).
          find ${cfg.settings.Rules.Path} -type l -lname '${builtins.storeDir}/*' ${optionalString (rules != {}) ''
            -not \( ${concatMapStringsSep " -o " ({ local, ... }:
              "-name '${baseNameOf local}*'")
            rules} \) \
          ''} -delete
          ${concatMapStrings ({ file, local }: ''
            ln -sf '${file}' "${local}"
          '') rules}
        '');
      };
      tmpfiles.rules = [
        "d ${cfg.settings.Rules.Path} 0750 root root - -"
        "L+ /etc/opensnitchd/system-fw.json - - - - ${pkgs.opensnitch}/etc/opensnitchd/system-fw.json"
      ];
    };

  };

  meta.maintainers = with lib.maintainers; [ onny ];
}

