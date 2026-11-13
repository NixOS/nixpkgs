{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.vpntui;
  helper = "${cfg.package}/libexec/vpntui/run-vpn";
in
{
  options.programs.vpntui = {
    enable = lib.mkEnableOption "vpntui, a per-application VPN panel built on Xray";

    package = lib.mkPackageOption pkgs "vpntui" { };

    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "alice" ];
      description = ''
        Users allowed to run the vpntui helper without a password.  The helper
        only creates a network namespace, starts Xray in it and runs the
        selected application as the invoking user; it never executes
        user-owned binaries as root.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.sessionVariables.VPNTUI_HELPER = helper;

    security.sudo.extraRules = map (user: {
      users = [ user ];
      commands = [
        {
          command = helper;
          options = [ "NOPASSWD" ];
        }
      ];
    }) cfg.users;
  };
}
