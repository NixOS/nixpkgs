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

      package =
        lib.mkPackageOption pkgs "1Password GUI" {
          default = [ "_1password-gui" ];
        }
        // {
          apply =
            pkg:
            pkg.override {
              inherit (cfg) polkitPolicyOwners;
            };
        };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    users.groups.onepassword.gid = config.ids.gids.onepassword;
    # The 1Password Environments MCP server (bundled with the desktop app as
    # share/1password/1password-mcp) verifies connecting peers via
    # SO_PEERCRED: the peer's effective GID must be the `onepassword-mcp`
    # group, which must be in the user range (GID >= 1000). Upstream's
    # install script creates this group and installs the binary as
    # root:onepassword-mcp mode 2755; neither happens in the Nix store, so
    # expose the binary through a setgid wrapper instead. The wrapper is
    # world-executable, mirroring upstream's mode 2755, so users do not need
    # to be group members.
    users.groups."onepassword-mcp".gid = config.ids.gids.onepassword-mcp;

    security.wrappers = {
      "1Password-BrowserSupport" = {
        source = "${cfg.package}/share/1password/1Password-BrowserSupport";
        owner = "root";
        group = "onepassword";
        setuid = false;
        setgid = true;
      };
      "1password-mcp" = {
        source = "${cfg.package}/share/1password/1password-mcp";
        owner = "root";
        group = "onepassword-mcp";
        setuid = false;
        setgid = true;
        permissions = "u+rx,g+rx,o+rx";
      };
    };
  };
}
