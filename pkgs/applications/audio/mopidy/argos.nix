{
  stdenv,
  lib,
  pkgs,
  python3Packages,
  fetchFromGitHub
}:
stdenv.mkDerivation rec {
  pname = "mopidy-argos";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "orontee";
    repo = "argos";
    rev = "refs/tags/v${version}";
    sha256 = "UOKzbC3/4YQTiXdVdGJCYjdVPHzK8vYo4IIb0ZKASac=";
  };
  format = "pyproject";

  nativeBuildInputs = [
    pkgs.pkg-config
    pkgs.meson
    pkgs.ninja
    pkgs.appstream-glib
    pkgs.desktop-file-utils
    pkgs.python3
    pkgs.wrapGAppsHook
    python3Packages.wrapPython
  ];

  propagatedBuildInputs = [
    pkgs.gobject-introspection
  ] ++ (with python3Packages; [
    aiohttp
    pycairo
    pygobject3
    pyxdg
  ]);

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    homepage = "https://github.com/orontee/argos";
    description = "Gtk front-end to control a Mopidy server";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.hufman ];
 };
}
