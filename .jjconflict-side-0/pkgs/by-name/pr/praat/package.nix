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
  fetchpatch2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "praat";
  version = "7.0.01";

  src = fetchFromGitHub {
    owner = "praat";
    repo = "praat.github.io";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LDE3xmZVjO/AuInLpH853tMit39MRKjtrtWLBNNm7qQ=";
  };

  # quick fix for now, better fix coming soon
  patches = [
    (fetchpatch2 {
      name = "CVE-2026-110698.patch";
      url = "https://github.com/praat/praat.github.io/commit/a910d21a2705ef4cd16d91f29cdc8da1ab1a7221.patch?full_index=1";
      hash = "sha256-JWpjTq2nJnlutD6pmb0OD38CslkUB7Wxm6NcJyZWwXE=";
    })
  ];

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
