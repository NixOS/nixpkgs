{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.sane.brscan5;

  netDeviceList = lib.attrValues cfg.netDevices;

  etcFiles = pkgs.callPackage ./brscan5_etc_files.nix { netDevices = netDeviceList; };

  netDeviceOpts =
    { name, ... }:
    {

      options = {

        name = lib.mkOption {
          type = lib.types.str;
          description = ''
            The friendly name you give to the network device. If undefined,
            the name of attribute will be used.
          '';

          example = "office1";
        };

        model = lib.mkOption {
          type = lib.types.str;
          description = ''
            The model of the network device.
          '';

          example = "ADS-1200";
        };

        ip = lib.mkOption {
          type = with lib.types; nullOr str;
          default = null;
          description = ''
            The ip address of the device. If undefined, you will have to
            provide a nodename.
          '';

          example = "192.168.1.2";
        };

        nodename = lib.mkOption {
          type = with lib.types; nullOr str;
          default = null;
          description = ''
            The node name of the device. If undefined, you will have to
            provide an ip.
          '';

          example = "BRW0080927AFBCE";
        };

      };

      config = {
        name = lib.mkDefault name;
      };
    };

in

{
  options = {

    hardware.sane.brscan5.enable = lib.mkEnableOption "the Brother brscan5 sane backend";

    hardware.sane.brscan5.netDevices = lib.mkOption {
      default = { };
      example = {
        office1 = {
          model = "MFC-7860DW";
          ip = "192.168.1.2";
        };
        office2 = {
          model = "MFC-7860DW";
          nodename = "BRW0080927AFBCE";
        };
      };
      type = with lib.types; attrsOf (submodule netDeviceOpts);
      description = ''
        The list of network devices that will be registered against the brscan5
        sane backend.
      '';
    };
  };

  config = lib.mkIf (config.hardware.sane.enable && cfg.enable) {

    hardware.sane.extraBackends = [
      pkgs.brscan5
    ];

    environment.etc."opt/brother/scanner/brscan5" = {
      source = "${etcFiles}/etc/opt/brother/scanner/brscan5";
    };
    environment.etc."opt/brother/scanner/models" = {
      source = "${etcFiles}/etc/opt/brother/scanner/brscan5/models";
    };
    environment.etc."sane.d/dll.d/brother5.conf".source =
      "${pkgs.brscan5}/etc/sane.d/dll.d/brother5.conf";

    assertions = [
      {
        assertion = lib.all (x: !(null != x.ip && null != x.nodename)) netDeviceList;
        message = ''
          When describing a network device as part of the attribute list
          `hardware.sane.brscan5.netDevices`, only one of its `ip` or `nodename`
          attribute should be specified, not both!
        '';
      }
    ];

  };
}
