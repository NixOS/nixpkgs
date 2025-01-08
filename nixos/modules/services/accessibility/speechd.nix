{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.speechd;
  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    mkPackageOption
    ;
in
{
  options.services.speechd = {
    # FIXME: figure out how to deprecate this EXTREMELY CAREFULLY
    # default guessed conservatively in ../misc/graphical-desktop.nix
    enable = lib.mkEnableOption "speech-dispatcher speech synthesizer daemon";
    package = lib.mkPackageOption pkgs "speechd" { };
  };

  # FIXME: speechd 0.12 (or whatever the next version is)
  # will support socket activation, so switch to that once it's out.
  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      sessionVariables.SPEECHD_CMD = getExe cfg.package;
    };
  };
}
