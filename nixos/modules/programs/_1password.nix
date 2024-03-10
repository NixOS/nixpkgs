{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.programs._1password;

in
{
  imports = [
    (mkRemovedOptionModule [ "programs" "_1password" "gid" ] ''
      A preallocated GID will be used instead.
    '')
  ];

  options = {
    programs._1password = {
      enable = mkEnableOption (lib.mdDoc "the 1Password CLI tool");

      package = mkPackageOption pkgs "1Password CLI" {
        default = [ "_1password" ];
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    users.groups.onepassword-cli.gid = config.ids.gids.onepassword-cli;

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
