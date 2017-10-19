{ config, pkgs, lib, ... }:

with lib;
{
  options.programs.sway.enable = mkEnableOption "sway";

  config = mkIf config.programs.sway.enable {
    environment.systemPackages = [ pkgs.sway pkgs.xwayland ];
    security.wrappers.sway = {
      source = "${pkgs.sway}/bin/sway";
      capabilities = "cap_sys_ptrace,cap_sys_tty_config=eip";
      owner = "root";
      group = "sway";
      permissions = "u+rx,g+rx";
    };

    users.extraGroups.sway = {};
  };
}
