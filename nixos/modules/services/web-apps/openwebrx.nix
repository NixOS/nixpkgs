{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.openwebrx;
in
{
  options.services.openwebrx = with lib; {
    enable = mkEnableOption "OpenWebRX Web interface for Software-Defined Radios on http://localhost:8073";

    package = mkPackageOption pkgs "openwebrx" { };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.openwebrx = {
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [
        alsa-utils
        codec2
        csdr
        dablin
        digiham
        dumphfdl
        dumpvdl2
        dump1090
        hamlib_4
        imagemagick
        js8call
        lame
        multimon-ng
        m17-cxx-demod
        netcat
        rtl_433
      ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/openwebrx";
        Restart = "always";
        DynamicUser = true;
        # openwebrx uses /var/lib/openwebrx by default
        StateDirectory = [ "openwebrx" ];
      };
    };
  };
}
