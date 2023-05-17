{ lib, buildPythonApplication, fetchFromGitHub, mpv, requests, python-mpv-jsonipc, pystray, tkinter
, wrapGAppsHook, gobject-introspection }:

buildPythonApplication rec {
  pname = "plex-mpv-shim";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-hUGKOJEDZMK5uhHoevFt1ay6QQEcoN4F8cPxln5uMRo=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
  ];

  propagatedBuildInputs = [ mpv requests python-mpv-jsonipc pystray tkinter ];

  # needed for pystray to access appindicator using GI
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
  dontWrapGApps = true;

  # does not contain tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/iwalton3/plex-mpv-shim";
    description = "Allows casting of videos to MPV via the Plex mobile and web app";
    license = licenses.mit;
  };
}
