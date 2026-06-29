{
  lib,
  fetchurl,
  appimageTools,
  pkgs,
}:
appimageTools.wrapType2 {
  pname = "early";
  version = "6.9.5";
  src = fetchurl {
    url = "https://web.archive.org/web/20260531143300/https://releases.early.app/linux/production/EARLY.AppImage";
    hash = "sha256-d+LJZHZcjWgemZ+a8pxtu/r7vBQ8MN9fEg0ZoM4EEY4=";
  };
  extraPkgs = pkgs: [ pkgs.libsecret ];
  meta = {
    description = "Time tracking app";
    longDescription = ''
      EARLY (formerly Timeular) is a time tracking app. The Timeular Tracker
      is an 8-sided die that sits on your desk. Assign an activity to each side
      and flip to start tracking your time.
    '';
    homepage = "https://early.app";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      ktor
      aln730
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "early";
  };
}
