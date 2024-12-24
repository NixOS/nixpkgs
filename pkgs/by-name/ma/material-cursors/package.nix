{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  inkscape,
  xcursorgen,
}:

stdenvNoCC.mkDerivation {
  pname = "material-cursors";
  version = "unstable-2023-11-30";

  src = fetchFromGitHub {
    owner = "varlesh";
    repo = "material-cursors";
    rev = "2a5f302fefe04678c421473bed636b4d87774b4a";
    hash = "sha256-uC2qx3jF4d2tGLPnXEpogm0vyC053MvDVVdVXX8AZ60=";
  };

  nativeBuildInputs = [
    inkscape
    xcursorgen
  ];

  buildPhase = ''
    runHook preBuild

    # Silences the inkscape warning spam.
    HOME=$(pwd) bash build.sh 2> /dev/null

    runHook postBuild
  '';

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Material cursors for Linux";
    homepage = "https://github.com/varlesh/material-cursors";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ RGBCube ];
  };
}
