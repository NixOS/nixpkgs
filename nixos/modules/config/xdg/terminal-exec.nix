{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.xdg.terminal-exec;
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    mkPackageOption
    types
    ;
in
{
  meta.maintainers = with lib.maintainers; [ Cryolitia ];

  ###### interface

  options = {
    xdg.terminal-exec = {
      enable = mkEnableOption "xdg-terminal-exec, the [proposed](https://gitlab.freedesktop.org/xdg/xdg-specs/-/merge_requests/46) Default Terminal Execution Specification";
      package = mkPackageOption pkgs "xdg-terminal-exec" { };
      settings = mkOption {
        type = with types; attrsOf (listOf str);
        default = { };
        description = ''
          Configuration options for the Default Terminal Execution Specification.

          The keys are the desktop environments that are matched (case-insensitively) against `$XDG_CURRENT_DESKTOP`,
          or `default` which is used when the current desktop environment is not found in the configuration.
          The values are a list of terminals' [desktop file IDs](https://specifications.freedesktop.org/desktop-entry-spec/latest/ar01s02.html#desktop-file-id) to try in order of decreasing priority.
        '';
        example = {
          default = [ "kitty.desktop" ];
          GNOME = [
            "com.raggesilver.BlackBox.desktop"
            "org.gnome.Terminal.desktop"
          ];
        };
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];

      etc = lib.mapAttrs' (
        desktop: terminals:
        # map desktop name such as GNOME to `xdg/gnome-xdg-terminals.list`, default to `xdg/xdg-terminals.list`
        lib.nameValuePair (
          "xdg/${if desktop == "default" then "" else "${lib.toLower desktop}-"}xdg-terminals.list"
        ) { text = lib.concatLines terminals; }
      ) cfg.settings;
    };
  };
}
