{ config, lib, pkgs, ... }:

let
  cfg = config.programs.virt-manager;
in
{
  options.programs.virt-manager = {
    enable = lib.mkEnableOption "virt-manager, an UI for managing virtual machines in libvirt";

    package = lib.mkPackageOption pkgs "virt-manager" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    programs.dconf = {
      profiles.user.databases = [
        {
          settings = {
            "org/virt-manager/virt-manager/connections" = {
              autoconnect = [ "qemu:///system" ];
              uris = [ "qemu:///system" ];
            };
          };
        }
      ];
    };
  };
}
