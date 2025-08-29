{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    attrNames
    attrsets
    concatStringsSep
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    nameValuePair
    lists
    types
    ;
  inherit (builtins)
    attrValues
    catAttrs
    hashString
    ;
in
{
  options = {
    networking.sqm = {
      enable = mkEnableOption ''
        Smart Queue Management (SQM).

        SQM provides a network a simplified Quality of Service (QoS) setup to help
        reduce jitter an latency of smaller, usually interactive flows,
        over larger flows which attempt to consume available bandwidth.

        SQM moves the point of congestion control away from upstream network
        devices such as modems, network termination unit or service provider traffic
        enforcement queuing. In essence, sacrificing a small percentage of your
        bandwidth to make your overall experience better.

        Enabling this really only makes sense when the host terminates
        one or more internet connections.

        See <https://github.com/tohojo/sqm-scripts> for configuration options.

        Configuration defaults from <https://github.com/tohojo/sqm-scripts/blob/main/src/defaults.sh>
      '';
      package = mkOption {
        type = types.package;
        default = pkgs.sqm-scripts;
        defaultText = literalExpression "pkgs.sqm-scripts";
        description = "The package containing the sqm-scripts";
      };
      kernelModules = mkOption {
        type = types.listOf types.str;
        default = [
          "sch_ingress"
          "act_mirred"
          "cls_fw"
          "cls_flow"
          "cls_u32"
          "sch_htb"
        ];
        description = "Required kernel modules, see src/default.sh";
      };
      settings = mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = {
          TARGET = "5ms";
        };
        description = ''
          Global configuraion that will be applied to all interfaces that can
          be superceeded by interface specific settings.
        '';
      };
      interfaces = mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              enable = mkEnableOption "SQM for this interface";
              uplinkKbps = mkOption {
                type = types.ints.positive;
                default = 1000;
                description = ''
                  Uplink/egress/upload bandwidth in kbps to shape at.
                  This should be set slightly lower (5% or so) than your available upload rate.
                '';
              };
              downlinkKbps = mkOption {
                type = types.ints.positive;
                default = 85000;
                description = ''
                  Downlink/ingress/download bandwidth in kbps to shape at.
                  This should be set slightly lower (5% or so) than your available download rate
                '';
              };
              script = mkOption {
                type = types.str;
                example = "layer_cake.qos";
                default = "piece_of_cake.qos";
                description = ''
                  The QoS scheme to use, under most circumstances piece_of_cake.qos is sufficient
                '';
              };
              queingDiscipline = mkOption {
                type = types.str;
                example = "fq_codel";
                default = "cake";
                description = "The queing strategy to use";
              };
              settings = mkOption {
                type = types.attrsOf types.str;
                default = { };
                example = {
                  TARGET = "5ms";
                };
                description = "Interface specific configuration";
              };
            };
          }
        );
        default = { };
        description = "Interfaces to enable SQM on";
      };
    };
  };
  config =
    let
      cfg = config.networking.sqm;

      kernelModules =
        map (qdisc: "sch_${qdisc}") (lists.unique (catAttrs "queingDiscipline" (attrValues cfg.interfaces)))
        ++ cfg.kernelModules;

      envVarScript =
        # Simple ENVVAR="value" translation
        values:
        concatStringsSep "\n" (attrsets.mapAttrsToList (name: value: ''${name}="${value}"'') values);

      configFiles = {
        "sqm/default.conf" = {
          text = concatStringsSep "\n" [
            (builtins.readFile "${cfg.package}/etc/sqm/default.conf")
            (envVarScript cfg.settings)
          ];
          mode = "0444";
        };
        "sqm/sqm.conf" = {
          text = concatStringsSep "\n" [
            (builtins.readFile "${cfg.package}/etc/sqm/sqm.conf")
            (envVarScript {
              SQM_LIB_DIR = "${cfg.package}/lib/sqm";
            })
          ];
          mode = "0444";
        };
      }
      // (attrsets.mapAttrs' (
        ifaceName: options:
        nameValuePair "sqm/${ifaceName}.iface.conf" {
          text = (
            envVarScript (
              options.settings
              // {
                ALL_MODULES = concatStringsSep " " ([ "sch_${options.queingDiscipline}" ] ++ kernelModules);
                DOWNLINK = toString options.downlinkKbps;
                ENABLED = if options.enable then "1" else "0";
                IFACE = ifaceName;
                QDISC = options.queingDiscipline;
                SCRIPT = options.script;
                UPLINK = toString options.uplinkKbps;
              }
            )
          );
          mode = "0444";
        }
      ) cfg.interfaces);

      interfaceUnits = map (interfaceName: "sqm@${interfaceName}.service") (attrNames cfg.interfaces);

    in
    mkIf cfg.enable {
      boot.kernelModules = kernelModules;
      environment = {
        etc = configFiles;
        systemPackages = [ cfg.package ];
      };
      systemd = {
        packages = [ cfg.package ];
        services."sqm@" = {
          # Overrides for upstream unit file
          overrideStrategy = "asDropin";
          path = [
            config.networking.firewall.package
            pkgs.iproute2
            pkgs.gawk
          ];
          # trigger service restarts on any configuration changes
          restartTriggers = map (file: (hashString "sha256" file.text)) (attrValues configFiles);
          serviceConfig = {
            ExecStart = [
              ""
              "${cfg.package}/lib/sqm/start-sqm"
            ];
            ExecStop = [
              ""
              "${cfg.package}/lib/sqm/stop-sqm"
            ];
          };
        };
        targets = {
          network.wants = interfaceUnits;
          # multi-user to avoid needing a reboot
          multi-user.wants = interfaceUnits;
        };
        tmpfiles.packages = [ cfg.package ];
      };
    };
}
