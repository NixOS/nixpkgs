{
  fetchFromGitHub,
  lib,
  makeWrapper,
  writeTextFile,

  curl,
  hexdump,
  python3,
  SDL2,
  stdenv,
  zlib,
  libGL,

  sm64baserom,
  enableCoopNet ? true,
  enableDiscord ? true,
  enableTextureFix ? true,
}:
let
  libc_hack = writeTextFile {
    name = "libc-hack";
    # https://stackoverflow.com/questions/21768542/libc-h-no-such-file-or-directory-when-compiling-nanomsg-pipeline-sample
    text = ''
      #include <unistd.h>
      #include <string.h>
      #include <pthread.h>
    '';
    destination = "/include/libc.h";
  };
  baserom =
    (sm64baserom.override {
      region = "us";
      showRegionMessage = false;
    }).romPath;
in
# note: there is a generic builder in pkgs/games/sm64ex/generic.nix that is meant to help build sm64ex and its forks; however sm64coopdx has departed significantly enough in its build that it doesn't make sense to use that other than the baseRom derivation
stdenv.mkDerivation (finalAttrs: {
  pname = "sm64coopdx";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "coop-deluxe";
    repo = "sm64coopdx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ct7X6LCitk1QID00guvYOMfIwnZccMeXqXwUB3ioKh8=";
  };

  patches = [ ./no-update-check.patch ];

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    curl
    hexdump
    libc_hack
    python3
    SDL2
    zlib
    libGL
  ];

  enableParallelBuilding = true;

  makeFlags = [
    "BREW_PREFIX=/not-exist"
    "DISCORD_SDK=${if enableDiscord then "1" else "0"}"
    "TEXTURE_FIX=${if enableTextureFix then "1" else "0"}"
    "COOPNET=${if enableCoopNet then "1" else "0"}"
  ];

  preBuild = ''
    # the baserom is needed both at build time and run time
    ln -s ${baserom} baserom.us.z64
    # remove -march flags, stdenv manages them
    substituteInPlace Makefile \
      --replace-fail ' -march=$(TARGET_ARCH)' ""
  '';

  installPhase = ''
    runHook preInstall

    local built=$PWD/build/us_pc
    local share=$out/share/sm64coopdx
    mkdir -p $share
    cp $built/sm64coopdx $share/sm64coopdx
    cp -r $built/{dynos,lang,mods,palettes} $share
    # the baserom is needed both at build time and run time
    ln -s ${baserom} $share/baserom.us.z64

    ${lib.optionalString enableDiscord ''
      cp $built/libdiscord_game_sdk* $share
    ''}

    # coopdx always tries to load resources from the binary's directory, with no obvious way to change. Thus this small wrapper script to always run from the /share directory that has all the resources
    mkdir -p $out/bin
    makeWrapper $share/sm64coopdx $out/bin/sm64coopdx \
      --chdir $share

    runHook postInstall
  '';

  meta = {
    description = "Multiplayer fork of the Super Mario 64 decompilation";
    longDescription = ''
      This is a fork of sm64ex-coop, which was itself a fork of sm64ex, which was a fork of the sm64 decompilation project.

      It allows multiple people to play within and across levels, has multiple character models, and mods in the form of lua scripts.

      Arguments:

      - `enableTextureFix`: (default: `true`) whether to enable texture fixes. Upstream describes disabling this as "for purists"
      - `enableDiscord`: (default: `true`) whether to enable discord integration, which allows showing status and connecting to games over discord
      - `enableCoopNet`: (default: `true`) whether to enable Co-op Net integration, a server made specifically for multiplayer sm64
    '';
    license = lib.licenses.unfree;
    platforms = lib.platforms.x86;
    maintainers = [ lib.maintainers.shelvacu ];
    mainProgram = "sm64coopdx";
    homepage = "https://sm64coopdx.com/";
    changelog = "https://github.com/coop-deluxe/sm64coopdx/releases/tag/v1.3";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      # The lua engine, discord sdk, and coopnet library are vendored pre-built. See https://github.com/coop-deluxe/sm64coopdx/tree/v1.0.3/lib
      binaryNativeCode
    ];
  };
})
