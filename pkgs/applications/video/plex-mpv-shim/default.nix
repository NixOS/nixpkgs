<<<<<<< HEAD
{ lib, buildPythonApplication, fetchFromGitHub, fetchpatch, python, mpv, requests, python-mpv-jsonipc, pystray, tkinter
, wrapGAppsHook, gobject-introspection, mpv-shim-default-shaders }:
=======
{ lib, buildPythonApplication, fetchFromGitHub, mpv, requests, python-mpv-jsonipc, pystray, tkinter
, wrapGAppsHook, gobject-introspection }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildPythonApplication rec {
  pname = "plex-mpv-shim";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-hUGKOJEDZMK5uhHoevFt1ay6QQEcoN4F8cPxln5uMRo=";
  };

<<<<<<< HEAD
  patches = [
    # pull in upstream commit to fix python-mpv dependency name -- remove when version > 1.11.0
    (fetchpatch {
      url = "https://github.com/iwalton3/plex-mpv-shim/commit/d8643123a8ec79216e02850b08f63b06e4e0a2ea.diff";
      hash = "sha256-nc+vwYnAtMjVzL2fIQeTAqhf3HBseL+2pFEtv8zNUXo=";
    })
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  postInstall = ''
    # put link to shaders where upstream package expects them
    ln -s ${mpv-shim-default-shaders}/share/mpv-shim-default-shaders $out/${python.sitePackages}/plex_mpv_shim/default_shader_pack
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # does not contain tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/iwalton3/plex-mpv-shim";
    description = "Allows casting of videos to MPV via the Plex mobile and web app";
<<<<<<< HEAD
    maintainers = with maintainers; [ devusb ];
    license = licenses.mit;
    platforms = platforms.linux;
=======
    license = licenses.mit;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
