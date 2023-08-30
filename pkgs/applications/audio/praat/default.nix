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
  version = "6.3.15";

  src = fetchFromGitHub {
    owner = "praat";
    repo = "praat";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Lo0aJ3BbFkZxAJZyOTzso9esYnkTkeKAFNUi7Q2d/hI=";
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

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

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
