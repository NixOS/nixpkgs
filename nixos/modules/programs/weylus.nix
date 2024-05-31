{ config, lib, pkgs, ... }:

let
  cfg = config.programs.weylus;
in
{
  options.programs.weylus = with lib.types; {
    enable = lib.mkEnableOption "weylus, which turns your smart phone into a graphic tablet/touch screen for your computer";

    openFirewall = lib.mkOption {
      type = bool;
      default = false;
      description = ''
        Open ports needed for the functionality of the program.
      '';
    };

     users = lib.mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        To enable stylus and multi-touch support, the user you're going to use must be added to this list.
        These users can synthesize input events system-wide, even when another user is logged in - untrusted users should not be added.
      '';
    };

    package = lib.mkPackageOption pkgs "weylus" { };
  };
  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 1701 9001 ];
    };

    hardware.uinput.enable = true;

    users.groups.uinput.members = cfg.users;

    environment.systemPackages = [ cfg.package ];
  };
}
