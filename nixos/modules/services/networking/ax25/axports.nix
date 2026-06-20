{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    types
    ;

  inherit (lib.strings)
    concatStringsSep
    optionalString
    ;

  inherit (lib.attrsets)
    filterAttrs
    mapAttrsToList
    mapAttrs'
    ;

  inherit (lib.modules)
    mkIf
    ;

  inherit (lib.options)
    mkEnableOption
    mkOption
    mkPackageOption
    ;

  cfg = config.services.ax25.axports;

  enabledAxports = filterAttrs (ax25Name: cfg: cfg.enable) cfg;

  axportsOpts = {

    options = {
      enable = mkEnableOption "Enables the axport interface";

      package = mkPackageOption pkgs "ax25-tools" { };

      tty = mkOption {
        type = types.str;
        example = "/dev/ttyACM0";
        description = ''
          Location of hardware kiss tnc for this interface.
        '';
      };

      callsign = mkOption {
        type = types.str;
        example = "WB6WLV-7";
        description = ''
          The callsign of the physical interface to bind to.
        '';
      };

      description = mkOption {
        type = types.str;
        # This cannot be empty since some ax25 tools cant parse /etc/ax25/axports without it
        default = "NixOS managed tnc";
        description = ''
          Free format description of this interface.
        '';
      };

      baud = mkOption {
        type = types.int;
        example = 57600;
        description = ''
          The serial port speed of this interface.
        '';
      };

      paclen = mkOption {
        type = types.int;
        default = 255;
        description = ''
          Default maximum packet size for this interface.
        '';
      };

      window = mkOption {
        type = types.int;
        default = 7;
        description = ''
          Default window size for this interface.
        '';
      };

      kissParams = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "-t 300 -l 10 -s 12 -r 80 -f n";
        description = ''
          Kissattach parameters for this interface.
        '';
      };
    };
  };
in
{

  options = {

    services.ax25.axports = mkOption {
      type = types.attrsOf (types.submodule axportsOpts);
      default = { };
      description = "Specification of one or more AX.25 ports.";
    };
  };

  config = mkIf (enabledAxports != { }) {

    system.requiredKernelConfig = [
      (config.lib.kernelConfig.isEnabled "ax25")
    ];

    environment.etc."ax25/axports" = {
      text = concatStringsSep "\n" (
        mapAttrsToList (
          portName: portCfg:
          "${portName} ${portCfg.callsign} ${toString portCfg.baud} ${toString portCfg.paclen} ${toString portCfg.window} ${portCfg.description}"
        ) enabledAxports
      );
      mode = "0644";
    };

    systemd.targets.ax25-axports = {
      description = "AX.25 axports group target";
    };

    systemd.services = mapAttrs' (portName: portCfg: {
      name = "ax25-kissattach-${portName}";
      value = {
        description = "AX.25 KISS attached interface for ${portName}";
        wantedBy = [ "multi-user.target" ];
        before = [ "ax25-axports.target" ];
        partOf = [ "ax25-axports.target" ];
        serviceConfig = {
          Type = "exec";
          ExecStart = "${portCfg.package}/bin/kissattach ${portCfg.tty} ${portName}";
        };
        postStart = optionalString (portCfg.kissParams != null) ''
          ${portCfg.package}/bin/kissparms -p ${portName} ${portCfg.kissParams}
        '';
      };
    }) enabledAxports;
  };
}
