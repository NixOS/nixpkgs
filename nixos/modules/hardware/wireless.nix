{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.hardware.wireless;

  setWirelessRegdom = pkgs.writeScript "set-wireless-regdom" ''
    #!/bin/sh
    ${lib.getExe pkgs.iw} reg set ${cfg.regulatoryDomain}
  '';

  udevRule = pkgs.writeTextFile {
    name = "regdom-udev-rule";
    text = ''
      # Set wireless regulatory domain at device creation

      ACTION=="add", SUBSYSTEM=="module", DEVPATH=="/module/cfg80211", RUN+="${setWirelessRegdom}"
    '';
    destination = "/lib/udev/rules.d/85-regulatory.rules";
  };
in
{
  options.hardware.wireless = {
    regulatoryDomain = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "DE";
      description = "Set the wireless regulatory domain";
    };
  };
  config = mkIf (cfg.regulatoryDomain != null) {
    services.udev.packages = [ udevRule ];
    hardware.wirelessRegulatoryDatabase = true;
  };
}
