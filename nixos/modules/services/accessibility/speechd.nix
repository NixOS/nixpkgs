{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.speechd;
  inherit (lib)
    mkEnableOption
    mkIf
    mkPackageOption
    ;
in
{
  options.services.speechd = {
    # FIXME: figure out how to deprecate this EXTREMELY CAREFULLY
    # default guessed conservatively in ../misc/graphical-desktop.nix
    enable = mkEnableOption "speech-dispatcher speech synthesizer daemon";
    package = mkPackageOption pkgs "speechd" { };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
    };
    systemd.packages = [ cfg.package ];
    # have to set `wantedBy` since `systemd.packages` ignores `[Install]`
    systemd.user.sockets.speech-dispatcher.wantedBy = [ "sockets.target" ];
  };
}
