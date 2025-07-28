{
  lib,
  fetchurl,
  fetchFromGitLab,
  python3Packages,
  gobject-introspection,
  gsettings-desktop-schemas,
  gtk3,
  wrapGAppsHook3,
  xrandr,
}:

let
  inherit (python3Packages) buildPythonApplication docutils pygobject3;
in
buildPythonApplication rec {
  pname = "arandr";
  version = "0.1.11";
  format = "setuptools";

  src = fetchFromGitLab {
    owner = "arandr";
    repo = "arandr";
    tag = version;
    hash = "sha256-nQtfOKAnWKsy2DmvtRGJa4+Y9uGgX41BeHpd9m4d9YA=";
  };

  # patch to set mtime=0 on setup.py
  patches = [ ./gzip-timestamp-fix.patch ];
  patchFlags = [ "-p0" ];

  preBuild = ''
    rm -rf data/po/*
  '';

  # no tests
  doCheck = false;

  buildInputs = [
    docutils
    gsettings-desktop-schemas
    gtk3
  ];
  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];
  propagatedBuildInputs = [
    xrandr
    pygobject3
  ];

  meta = with lib; {
    homepage = "https://christian.amsuess.com/tools/arandr/";
    description = "Simple visual front end for XRandR";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gepbird ];
    mainProgram = "arandr";
  };
}
