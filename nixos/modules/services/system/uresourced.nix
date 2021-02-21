{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.uresourced;

in

{
  options = {
    services.uresourced = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Uresourced, a daemon that dynamically assigns a resource allocation to the active graphical user.
          If the user has an active graphical session managed using systemd (e.g. GNOME), then the memory
          allocation will be used to protect the sessions core processes (session.slice)";
      '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.packages = [
      pkgs.uresourced
    ];

    services.dbus.packages = [
      pkgs.uresourced
    ];

    environment.etc."uresourced.conf".source = "${pkgs.uresourced}/etc/uresourced.conf";
  };
}
