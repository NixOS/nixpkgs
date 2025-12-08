{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  lua,
  glib,
}:

stdenv.mkDerivation {
  pname = "pinsel";
  version = "0-unstable-2022-03-27";

  src = fetchFromGitHub {
    owner = "Nooo37";
    repo = "pinsel";
    rev = "4955b93365a1816bffbddc3d2ddfe3f4b3d60107";
    hash = "sha256-H5DCAb8lJx2W4LNeGV+WOIiLUHsRVv1gSU2YMegkDFM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    glib
  ];

  buildInputs = [
    lua
    gtk3
  ];

  makeFlags = [ "INSTALLDIR=${placeholder "out"}/bin" ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = with lib; {
    description = "Minimal screenshot annotation tool with lua config";
    homepage = "https://github.com/Nooo37/pinsel";
    license = licenses.mit;
    maintainers = with maintainers; [ lom ];
    platforms = platforms.linux;
    mainProgram = "pinsel";
  };
}
