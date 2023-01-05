{ lib, callPackage, stdenv
, debugSupport ? false
, guiSupport ? true, dbus ? null # GUI (disable to run headless)
, webuiSupport ? true # WebUI
, trackerSearch ? true, python3 ? null
}:

with lib;
let
  pname = "qbittorrent";
  version = "4.4.5";

  meta = with lib; {
    description = "Featureful free software BitTorrent client";
    homepage    = "https://www.qbittorrent.org/";
    changelog   = "https://github.com/qbittorrent/qBittorrent/blob/release-${version}/Changelog";
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ Anton-Latukha ];
  };

  package = (callPackage (if stdenv.isLinux then ./linux.nix else ./darwin.nix)
    (if stdenv.isLinux then {
      inherit version meta pname debugSupport guiSupport dbus webuiSupport trackerSearch python3;
    } else {
      inherit version meta pname;
    }));
in package
