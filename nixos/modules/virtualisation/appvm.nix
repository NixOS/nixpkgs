{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualisation.appvm;

in {

  options = {
    virtualisation.appvm = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          This enables AppVMs and related virtualisation settings.
        '';
      };
      user = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          AppVM user login. Currently only AppVMs are supported for a single user only.
        '';
      };
    };

  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu.verbatimConfig = ''
        namespaces = []
        user = "${cfg.user}"
        group = "users"
        remember_owner = 0
      '';
    };

    users.users."${cfg.user}" = {
      packages = [ pkgs.appvm ];
      extraGroups = [ "libvirtd" ];
    };

  };

}

