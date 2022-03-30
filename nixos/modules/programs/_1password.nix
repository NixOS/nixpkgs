{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs._1password;
in {
  options = {
    programs._1password = {
      enable = mkEnableOption "The 1Password CLI tool with biometric unlock and integration with the 1Password GUI.";

      groupId = mkOption {
        type = types.int;
        example = literalExpression "5001";
        description = ''
          The GroupID to assign to the onepassword-cli group, which is needed for integration with the 1Password GUI. The group ID must be 1000 or greater.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs._1password;
        defaultText = literalExpression "pkgs._1password";
        example = literalExpression "pkgs._1password";
        description = ''
          The 1Password CLI derivation to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    users.groups.onepassword-cli.gid = cfg.groupId;

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
