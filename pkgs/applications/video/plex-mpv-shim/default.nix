{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  fetchpatch,
  python,
  mpv,
  requests,
  python-mpv-jsonipc,
  pystray,
  tkinter,
  wrapGAppsHook3,
  gobject-introspection,
  mpv-shim-default-shaders,
}:

buildPythonApplication {
  pname = "plex-mpv-shim";
  version = "1.11.0-unstable-2025-03-17";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = "plex-mpv-shim";
    rev = "fb1f1f3325285e33f9ce3425e9361f5f99277d9a"; # Fetch from this commit to include fixes for python library issues. Should be reverted to release 1.12.0
    hash = "sha256-tk+bIS93Y726sbrRXEyS7+4ku+g40Z7Aj0++wItjW2s=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  propagatedBuildInputs = [
    mpv
    requests
    python-mpv-jsonipc
    pystray
    tkinter
  ];

  # needed for pystray to access appindicator using GI
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
  dontWrapGApps = true;

  postInstall = ''
    # put link to shaders where upstream package expects them
    ln -s ${mpv-shim-default-shaders}/share/mpv-shim-default-shaders $out/${python.sitePackages}/plex_mpv_shim/default_shader_pack
  '';

  # does not contain tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/iwalton3/plex-mpv-shim";
    description = "Allows casting of videos to MPV via the Plex mobile and web app";
    maintainers = with maintainers; [ devusb ];
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "plex-mpv-shim";
  };
}
