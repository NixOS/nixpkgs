{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.programs._1password;

in
{
  options = {
    programs._1password = {
      enable = mkEnableOption "the 1Password CLI tool";

      gid = mkOption {
        type = types.addCheck types.int (x: x >= 1000);
        example = literalExpression "5001";
        description = ''
          The gid to assign to the onepassword-cli group, which is needed for integration with the 1Password GUI.
          It must be 1000 or greater.
        '';
      };

      package = mkPackageOption pkgs "1Password CLI" {
        default = [ "_1password" ];
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    users.groups.onepassword-cli.gid = cfg.gid;

    security.wrappers = {
      "op" = {
        source = "${cfg.package}/bin/op";
        owner = "root";
        group = "onepassword-cli";
        setuid = false;
        setgid = true;
      };
    };
  };
}
