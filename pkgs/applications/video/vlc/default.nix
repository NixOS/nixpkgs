{ lib, stdenv, fetchurl, callPackage, chromecastSupport ? true
, jackSupport ? false, onlyLibVLC ? false, skins2Support ? !onlyLibVLC
, waylandSupport ? true, withQt5 ? true, libcaca, qtbase, qtsvg, qtx11extras
, wrapQtAppsHook }:

# chromecastSupport requires TCP port 8010 to be open for it to work.
# If your firewall is enabled, make sure to have something like:
#   networking.firewall.allowedTCPPorts = [ 8010 ];

let
  inherit (lib) optionalString optional optionals;
  version = "3.0.18";

  meta = with lib; {
    description = "Cross-platform media player and streaming server";
    homepage = "http://www.videolan.org/vlc/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; (if onlyLibVLC then linux else linux ++ darwin);
  };

  package = (callPackage (if stdenv.isLinux then ./linux.nix else ./darwin.nix)
    (if stdenv.isLinux then {
      inherit version meta chromecastSupport jackSupport onlyLibVLC
        skins2Support waylandSupport libcaca withQt5 qtbase qtsvg qtx11extras
        wrapQtAppsHook;
    } else {
      inherit version meta;
    }));
in package
