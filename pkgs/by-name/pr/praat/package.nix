{
  alsa-lib,
  fetchFromGitHub,
  gtk3,
  lib,
  libpulseaudio,
  pkg-config,
  stdenv,
  wrapGAppsHook3,
  libjack2,
  iconConvTools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "praat";
  version = "6.4.63";

  src = fetchFromGitHub {
    owner = "praat";
    repo = "praat.github.io";
    tag = "v${finalAttrs.version}";
    hash = "sha256-96fw5WRk1/zex65hcRdmx0wq2FTVett3FRDPhmsZr6g=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    iconConvTools
  ];

  buildInputs = [
    alsa-lib
    gtk3
    libpulseaudio
    libjack2
  ];

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  configurePhase = ''
    runHook preConfigure

    cp makefiles/makefile.defs.linux.pulse-gcc.${
      if stdenv.hostPlatform.isLittleEndian then "LE" else "BE"
    } makefile.defs

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin praat
    install -Dm444 main/praat.desktop -t $out/share/applications
    icoFileToHiColorTheme main/praat.ico praat $out
    install -Dm444 main/praat-480.svg $out/share/icons/hicolor/scalable/apps/praat.svg

    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Doing phonetics by computer";
    mainProgram = "praat";
    homepage = "https://www.fon.hum.uva.nl/praat/";
    changelog = "https://github.com/praat/praat.github.io/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus; # Has some 3rd-party code in it though
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = lib.platforms.linux;
  };
})
