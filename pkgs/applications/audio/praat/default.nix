<<<<<<< HEAD
{
  alsa-lib
, fetchFromGitHub
, gtk3
, lib
, libpulseaudio
, pkg-config
, stdenv
, wrapGAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "praat";
  version = "6.3.16";
=======
{ lib, stdenv, fetchFromGitHub, pkg-config, wrapGAppsHook, alsa-lib, gtk3, libpulseaudio }:

stdenv.mkDerivation rec {
  pname = "praat";
  version = "6.3.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "praat";
    repo = "praat";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-0g16EblefuUU99RgcwtGrPWniGGlOt6GjVjyNdzN3GY=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    alsa-lib
    gtk3
    libpulseaudio
  ];
=======
    rev = "v${version}";
    sha256 = "sha256-wnw8GKMukiraZgMMzd3S2NldC/cnRSILNo+D1Rqhr4k=";
  };

  configurePhase = ''
    cp makefiles/makefile.defs.linux.pulse makefile.defs
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

<<<<<<< HEAD
  configurePhase = ''
    runHook preConfigure

    cp makefiles/makefile.defs.linux.pulse makefile.defs

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin praat

    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Doing phonetics by computer";
    homepage = "https://www.fon.hum.uva.nl/praat/";
    license = lib.licenses.gpl2Plus; # Has some 3rd-party code in it though
    maintainers = with lib.maintainers; [ orivej ];
    platforms = lib.platforms.linux;
  };
})
=======
  installPhase = ''
    install -Dt $out/bin praat
  '';

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];
  buildInputs = [ alsa-lib gtk3 libpulseaudio ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Doing phonetics by computer";
    homepage = "https://www.fon.hum.uva.nl/praat/";
    license = licenses.gpl2Plus; # Has some 3rd-party code in it though
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
