{
  alsa-lib,
  fetchFromGitHub,
  gtk3,
  lib,
  libpulseaudio,
  pkg-config,
  stdenv,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "praat";
  version = "6.4.47";

  src = fetchFromGitHub {
    owner = "praat";
    repo = "praat.github.io";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g0y2iRSwxFZepfViGNvKFeNe6BOoY90aKiogqNZov7w=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
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

    cp makefiles/makefile.defs.linux.pulse-gcc makefile.defs

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin praat
    install -Dm444 main/praat.desktop -t $out/share/applications
    install -Dm444 main/praat-32.ico $out/share/icons/hicolor/32x32/apps/praat.ico
    install -Dm444 main/praat-256.ico $out/share/icons/hicolor/256x256/apps/praat.ico
    install -Dm444 main/praat-480.png $out/share/icons/hicolor/480x480/apps/praat.png
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
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
