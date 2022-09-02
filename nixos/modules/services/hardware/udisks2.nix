# Udisks daemon.

{ config, lib, pkgs, ... }:

with lib;

let
  settingsFormat = pkgs.formats.ini {
    listToValue = concatMapStringsSep "," (generators.mkValueStringDefault {});
  };
  configFiles = mapAttrs (name: value: (settingsFormat.generate name value)) (mapAttrs' (name: value: nameValuePair name value ) config.services.udisks2.settings);
in

{

  ###### interface

  options = {

    services.udisks2 = {

      enable = mkEnableOption (lib.mdDoc "udisks2, a DBus service that allows applications to query and manipulate storage devices.");

      settings = mkOption rec {
        type = types.attrsOf settingsFormat.type;
        apply = recursiveUpdate default;
        default = {
          "udisks2.conf" = {
            udisks2 = {
              modules = [ "*" ];
              modules_load_preference = "ondemand";
            };
            defaults = {
              encryption = "luks2";
            };
          };
        };
        example = literalExpression ''
        {
          "WDC-WD10EZEX-60M2NA0-WD-WCC3F3SJ0698.conf" = {
            ATA = {
              StandbyTimeout = 50;
            };
          };
        };
        '';
        description = lib.mdDoc ''
          Options passed to udisksd.
          See [here](http://manpages.ubuntu.com/manpages/latest/en/man5/udisks2.conf.5.html) and
          drive configuration in [here](http://manpages.ubuntu.com/manpages/latest/en/man8/udisks.8.html) for supported options.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.udisks2.enable {

    environment.systemPackages = [ pkgs.udisks2 ];

    environment.etc = mapAttrs' (name: value: nameValuePair "udisks2/${name}" { source = value; } ) configFiles;

    security.polkit.enable = true;

    services.dbus.packages = [ pkgs.udisks2 ];

    systemd.tmpfiles.rules = [ "d /var/lib/udisks2 0755 root root -" ];

    services.udev.packages = [ pkgs.udisks2 ];

    systemd.packages = [ pkgs.udisks2 ];
  };

}
