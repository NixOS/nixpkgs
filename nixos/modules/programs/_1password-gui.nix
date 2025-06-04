{
  config,
  pkgs,
  lib,
  ...
}:

let

  cfg = config.programs._1password-gui;

in
{
  imports = [
    (lib.mkRemovedOptionModule [ "programs" "_1password-gui" "gid" ] ''
      A preallocated GID will be used instead.
    '')
  ];

  options = {
    programs._1password-gui = {
      enable = lib.mkEnableOption "the 1Password GUI application";

      polkitPolicyOwners = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = lib.literalExpression ''["user1" "user2" "user3"]'';
        description = ''
          A list of users who should be able to integrate 1Password with polkit-based authentication mechanisms.
        '';
      };

      package = lib.mkPackageOption pkgs "1Password GUI" {
        default = [ "_1password-gui" ];
      };
    };
  };

  config =
    let
      package = cfg.package.override {
        polkitPolicyOwners = cfg.polkitPolicyOwners;
      };
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [ package ];
      users.groups.onepassword.gid = config.ids.gids.onepassword;

      security.wrappers = {
        "1Password-BrowserSupport" = {
          source = "${package}/share/1password/1Password-BrowserSupport";
          owner = "root";
          group = "onepassword";
          setuid = false;
          setgid = true;
        };
      };

    };
}
