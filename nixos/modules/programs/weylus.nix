{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.weylus;
in
{
  options.programs.weylus = with types; {
    enable = mkEnableOption "weylus";

    openFirewall = mkOption {
      type = bool;
      default = false;
      description = lib.mdDoc ''
        Open ports needed for the functionality of the program.
      '';
    };

     users = mkOption {
      type = listOf str;
      default = [ ];
      description = lib.mdDoc ''
        To enable stylus and multi-touch support, the user you're going to use must be added to this list.
        These users can synthesize input events system-wide, even when another user is logged in - untrusted users should not be added.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.weylus;
      defaultText = "pkgs.weylus";
      description = lib.mdDoc "Weylus package to install.";
    };
  };
  config = mkIf cfg.enable {
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 1701 9001 ];
    };

    hardware.uinput.enable = true;

    users.groups.uinput.members = cfg.users;

    environment.systemPackages = [ cfg.package ];
  };
}
