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
<<<<<<< HEAD
  version = "0-unstable-2022-03-27";
=======
  version = "unstable-2021-09-13";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Nooo37";
    repo = "pinsel";
<<<<<<< HEAD
    rev = "4955b93365a1816bffbddc3d2ddfe3f4b3d60107";
    hash = "sha256-H5DCAb8lJx2W4LNeGV+WOIiLUHsRVv1gSU2YMegkDFM=";
=======
    rev = "24b0205ca041511b3efb2a75ef296539442f9f54";
    sha256 = "sha256-w+jiKypZODsmZq3uWGNd8PZhe1SowHj0thcQTX8WHfQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Minimal screenshot annotation tool with lua config";
    homepage = "https://github.com/Nooo37/pinsel";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Minimal screenshot annotation tool with lua config";
    homepage = "https://github.com/Nooo37/pinsel";
    # no license
    license = licenses.unfree;
    maintainers = with maintainers; [ lom ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "pinsel";
  };
}
