{ config, lib, pkgs, ... }:

let
  smartctlGroup = "smartctl";
in
{
  meta.maintainers = with lib.maintainers; [ bjornfor ];

  options = {
    programs.smartctl = {
      enable = lib.mkEnableOption "smartctl setuid wrapper, available to users in the ${smartctlGroup} group";
    };
  };

  config = lib.mkIf config.programs.smartctl.enable {
    security.wrappers.smartctl = {
      source = "${pkgs.smartmontools}/bin/smartctl";
      owner = "root";
      group = smartctlGroup;
      setuid = true;
      setgid = false;
      permissions = "u+rx,g+rx,o-rwx";
    };

    users.groups."${smartctlGroup}" = {};
  };
}
