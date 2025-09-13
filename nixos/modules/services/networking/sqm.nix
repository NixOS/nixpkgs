{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    attrNames
    literalExpression
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;
in
{
  options = {
    networking.sqm = {
      enable = mkEnableOption ''
        Whether to enable Smart Queue Management (SQM).

        SQM provides anetwork a simplified Quality of Service (QoS) setup to help
        reduce jitter an latency of smaller, usually interactive flows,
        over larger flows which attempt to consume available bandwith.

        SQM moves the point of congestion control away from upstream network
        devices such as modems, network termination unut  or service provider traffic
        enforcement queing.  In essence, sacrificing a small percentage of your
        bandwidth to make your overall experience better.

        Enabling this really only makes sense when the host terminates
        one or more internet connections.

        See https://github.com/tohojo/sqm-scripts for more details.
      '';
      package = mkOption {
        type = types.package;
        default = pkgs.sqm-scripts;
        defaultText = literalExpression ''pkgs.sqm-scripts'';
        description = "The package containing the sqm-scripts";
      };
      uplinkKbps = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 1000;
        description = ''
          Global uplink/egress/upload bandwidth in kbps to shape at.
          This should be set slightly lower (5% or so) than your available upload rate.
        '';
      };
      downlinkKbps = mkOption {
        type = types.nullOr types.int;
        example = 85000;
        default = null;
        description = ''
          Global downlink/ingress/download bandwidth in kbps to shape at.
          This should be set slightly lower (5% or so) than your available download rate
        '';
      };
      script = mkOption {
        type = types.str;
        example = "layer_cake.qos";
        default = "piece_of_cake.qos";
        description = "The QoS scheme to use";
      };
      settings = mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = {
          QDISC = "cake";
          TARGET = "5ms";
        };
        description = "Optional/advanced config that will be applied to all interfaces";
      };
      interfaces = mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              enable = mkEnableOption ''Enable SQM on the interface'';
              uplinkKbps = mkOption {
                type = types.nullOr types.int;
                default = config.networking.sqm.uplinkKbps;
                defaultText = literalExpression "config.networking.sqm.uplinkKbps";
                example = 1000;
                description = ''
                  Uplink/egress/upload bandwidth in kbps to shape at.
                  This should be set slightly lower (5% or so) than your available upload rate.
                '';
              };
              downlinkKbps = mkOption {
                type = types.nullOr types.int;
                example = 85000;
                default = config.networking.sqm.downlinkKbps;
                defaultText = literalExpression "config.networking.sqm.downlinkKbps";
                description = ''
                  Downlink/ingress/download bandwidth in kbps to shape at.
                  This should be set slightly lower (5% or so) than your available download rate
                '';
              };
              script = mkOption {
                type = types.str;
                default = config.networking.sqm.script;
                defaultText = literalExpression "config.networking.sqm.script";
                example = "layer_cake.qos";
                description = "The QoS script to use";
              };
              settings = mkOption {
                type = types.attrsOf types.str;
                default = { };
                example = {
                  QDISC = "cake";
                  TARGET = "5ms";
                };
                description = "Optiona/advanced config that will be applied this interfaces";
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
      mkAssertions =
        interface:
        lib.optionals cfg.interfaces.${interface}.enable [
          {
            assertion = cfg.interfaces.${interface}.uplinkKbps != null;
            message = "Setting `uplinkKbps` needs to be set in either top level or interface settings";
          }
          {
            assertion = cfg.interfaces.${interface}.downlinkKbps != null;
            message = "Setting `downlinkKbps` needs to be set in either top level or interface settings";
          }
        ];

      mkSystemdServiceUnit =
        interface:
        let
          sqmStateDirName = "sqm";
          targets = [
            "multi-user.target" # Seems to need reboot without this
            "network.target"
          ];
        in
        {
          "networking-sqm-${interface}" = mkIf cfg.interfaces.${interface}.enable {
            after = [ "sys-subsystem-net-devices-${interface}.device" ];
            before = targets;
            bindsTo = [ "sys-subsystem-net-devices-${interface}.device" ];
            environment = rec {
              # /etc/sqm/sqm.conf defaults
              SQM_LIB_DIR = "${cfg.package}/lib/sqm";
              SQM_STATE_DIR = "/run/${sqmStateDirName}";
              SQM_QDISC_STATE_DIR = "${SQM_STATE_DIR}/available_qdiscs";
              SQM_CHECK_QDISCS = "fq_codel codel pie sfq cake";
              SQM_SYSLOG = "0";
            }
            // cfg.settings
            // cfg.interfaces.${interface}.settings
            // {
              UPLINK = builtins.toString cfg.interfaces.${interface}.uplinkKbps;
              DOWNLINK = builtins.toString cfg.interfaces.${interface}.downlinkKbps;
              SCRIPT = cfg.interfaces.${interface}.script;
              # default sqm@.service Environment settings
              IFACE = interface;
              ENABLE = "1";
            };
            path = [
              config.networking.firewall.package
              pkgs.iproute2
              pkgs.gawk
            ];
            serviceConfig = {
              ExecStart = "${cfg.package}/lib/sqm/start-sqm";
              ExecStop = "${cfg.package}/lib/sqm/stop-sqm";
              RemainAfterExit = "1";
              RuntimeDirectory = sqmStateDirName;
              RuntimeDirectoryPreserve = "true";
              Type = "oneshot";
            };
            unitConfig = {
              Description = "SQM scripts for iface ${interface}";
            };
            wantedBy = targets;
            wants = targets;
          };
        };
    in
    mkIf cfg.enable {
      assertions = mkMerge (map mkAssertions (attrNames cfg.interfaces));
      boot.kernelModules = [
        "act_mirred"
        "cls_flow"
        "cls_fw"
        "cls_u32"
        "sch_cake"
        "sch_fq_codel"
        "sch_htb"
        "sch_ingress"
      ];
      environment.etc."sqm/sqm.conf" = {
        text = "# All config options are set on systemd units";
        mode = "0440";
      };
      systemd.services = mkMerge (map mkSystemdServiceUnit (attrNames cfg.interfaces));
    };
}
