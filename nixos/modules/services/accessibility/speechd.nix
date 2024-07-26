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
    enable = mkEnableOption "speech-dispatcher speech synthesizer daemon" // {
      default = true;
    };
    package = mkPackageOption pkgs "speechd" { };
  };

  # FIXME: speechd 0.12 (or whatever the next version is)
  # will support socket activation, so switch to that once it's out.
  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      sessionVariables.SPEECHD_CMD = getExe cfg.package;
    };
  };
}
