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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "praat";
  version = "6.6.30";

  src = fetchFromGitHub {
    owner = "praat";
    repo = "praat.github.io";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D6XnrN+pvUpgUcgyU8pEtuOx2cIMoSm8Px0+f5xi1aM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
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

  buildFlags = [ "PRAAT_AUDIO=pulse" ];
  installFlags = [ "PREFIX=${placeholder "out"}" ];

  enableParallelBuilding = true;

  postInstall = ''
    mv $out/share/applications/org.praat.Praat.desktop $out/share/applications/praat.desktop
  '';

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
