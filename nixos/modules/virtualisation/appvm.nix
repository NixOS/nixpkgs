{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.virtualisation.appvm;

in
{

  options = {
    virtualisation.appvm = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          This enables AppVMs and related virtualisation settings.
        '';
      };
      user = lib.mkOption {
        type = lib.types.str;
        description = ''
          AppVM user login. Currently only AppVMs are supported for a single user only.
        '';
      };
    };

  };

  config = lib.mkIf cfg.enable {
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
