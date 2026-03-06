{
  lib,
  stdenv,
  SDL2,
  fetchFromGitHub,
  gzip,
  libGL,
  libGLU,
  libvorbis,
  libmad,
  flac,
  libogg,
  libxmp,
  curlMinimal,
  zlib,
  gnutls,
  libx11,
  copyDesktopItems,
  makeDesktopItem,
  pkg-config,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "qss-m";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "timbergeron";
    repo = "QSS-M";
    tag = finalAttrs.version;
    hash = "sha256-Dm9NsSe6+V1bBgtANl1R9Rvir4QkiQUCi0jdYBqevPA=";
  };

  sourceRoot = "${finalAttrs.src.name}/Quake";

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
  ];

  buildInputs = [
    gzip
    libGL
    libGLU
    libvorbis
    libmad
    flac
    libogg
    libxmp
    SDL2
    curlMinimal
    zlib
    gnutls
    libx11
  ];

  buildFlags = [
    "DO_USERDIRS=1"
    "USE_CODEC_OPUS=0"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 quakespasm $out/bin/qss-m
    install -Dm644 ../Misc/QuakeSpasm_512.png $out/share/icons/hicolor/512x512/apps/qss-m.png
    runHook postInstall
  '';

  enableParallelBuilding = true;

  desktopItems = [
    (makeDesktopItem {
      name = "qss-m";
      exec = finalAttrs.meta.mainProgram;
      icon = "qss-m";
      comment = finalAttrs.meta.description;
      desktopName = "QSS-M";
      categories = [ "Game" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multiplayer-focused engine for iD software's Quake";
    homepage = "https://qssm.quakeone.com/";
    longDescription = ''
      QSS-M is an open source port of the original ID Software Quake.
      Over 30 years Quake 1.09 became Fitzquake to Quakespasm that led to Quakespasm
      Spiked and now Quakespasm Spiked Multiplayer (QSS-M). NetQuake competitive
      multiplayer clients started with ProQuake, transitioned to Qrack or Mark V,
      and now QSS-M made possible by all those voluntary efforts.
    '';
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ twicefoldampersands ];
    mainProgram = "qss-m";
  };
})
