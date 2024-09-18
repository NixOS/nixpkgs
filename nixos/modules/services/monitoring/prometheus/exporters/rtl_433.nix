{ config, lib, pkgs, options, ... }:

let
  cfg = config.services.prometheus.exporters.rtl_433;
in
{
  port = 9550;

  extraOpts = let
    mkMatcherOptionType = field: description: with lib.types;
      listOf (submodule {
        options = {
          name = lib.mkOption {
            type = str;
            description = "Name to match.";
          };
          "${field}" = lib.mkOption {
            type = int;
            description = description;
          };
          location = lib.mkOption {
            type = str;
            description = "Location to match.";
          };
        };
      });
  in
  {
    rtl433Flags = lib.mkOption {
      type = lib.types.str;
      default = "-C si";
      example = "-C si -R 19";
      description = ''
        Flags passed verbatim to rtl_433 binary.
        Having `-C si` (the default) is recommended since only Celsius temperatures are parsed.
      '';
    };
    channels = lib.mkOption {
      type = mkMatcherOptionType "channel" "Channel to match.";
      default = [];
      example = [
        { name = "Acurite"; channel = 6543; location = "Kitchen"; }
      ];
      description = ''
        List of channel matchers to export.
      '';
    };
    ids = lib.mkOption {
      type = mkMatcherOptionType "id" "ID to match.";
      default = [];
      example = [
        { name = "Nexus"; id = 1; location = "Bedroom"; }
      ];
      description = ''
        List of ID matchers to export.
      '';
    };
  };

  serviceOpts = {
    serviceConfig = {
      # rtl-sdr udev rules make supported USB devices +rw by plugdev.
      SupplementaryGroups = "plugdev";
      # rtl_433 needs rw access to the USB radio.
      PrivateDevices = lib.mkForce false;
      DeviceAllow = lib.mkForce "char-usb_device rw";
      RestrictAddressFamilies = [ "AF_NETLINK" ];

      ExecStart = let
        matchers = (map (m:
          "--channel_matcher '${m.name},${toString m.channel},${m.location}'"
        ) cfg.channels) ++ (map (m:
          "--id_matcher '${m.name},${toString m.id},${m.location}'"
        ) cfg.ids); in ''
        ${pkgs.prometheus-rtl_433-exporter}/bin/rtl_433_prometheus \
          -listen ${cfg.listenAddress}:${toString cfg.port} \
          -subprocess "${pkgs.rtl_433}/bin/rtl_433 -F json ${cfg.rtl433Flags}" \
          ${lib.concatStringsSep " \\\n  " matchers} \
          ${lib.concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
