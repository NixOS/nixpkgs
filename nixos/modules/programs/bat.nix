{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption mkPackageOption mkOption;
  inherit (lib.modules) mkIf;
  inherit (lib.lists) optionals;
  inherit (lib.types) lines;
  inherit (lib) maintainers;
  cfg = config.programs.bat;
in
{
  options.programs.bat = {
    enable = mkEnableOption "`bat`, a {manpage}`cat(1)` clone with wings";
    package = mkPackageOption pkgs "bat" { };
    enableExtras = mkEnableOption "`bat`'s extra scripts and utilities";
    # TODO: Somehow turn this into a structured submodule per RFC 0042.
    # `bat`'s configuration syntax translates particularly terribly to
    # Nix as some options can be declared multiple times and many options
    # are actually aliases to other options and shouldn't be set together.
    extraConfig = mkOption {
      default = "";
      example = ''
        --theme="TwoDark"
        --italic-text=always
        --paging=never
        --pager="less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse"
        --map-syntax "*.ino:C++"
        --map-syntax ".ignore:Git Ignore"
      '';
      description = ''
        Lines to be appended verbatim to the system-wide `bat` configuration file.
      '';
      type = lines;
    };
  };
  config = mkIf cfg.enable {
    environment = {
      systemPackages =
        [ cfg.package ]
        ++ optionals cfg.enableExtras (
          with pkgs.bat-extras;
          [
            batdiff
            batgrep
            batman
            batpipe
            batwatch
            prettybat
          ]
        );
      etc."bat/config".text = cfg.extraConfig;
    };
  };
  meta.maintainers = with maintainers; [ sigmasquadron ];
}
