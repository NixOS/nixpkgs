{
  lib,
  stdenv,
  fetchFromGitHub,
  sm64baserom,
  hexdump,
  pkg-config,
  python3,
  apcpp,
  audiofile,
  ixwebsocket,
  libGL,
  SDL2,
  zlib,
  fetchpatch,
  cmake,
  region ? "us",
  bettercamera ? false,
  nodrawingdistance ? false,
  texture_fix ? false,
  _60fps ? true,
  always-nonstop ? false,
  extended-moveset ? false,
}:
let
  baseRom = (sm64baserom.override { inherit region; }).romPath;
in
stdenv.mkDerivation (finalAttrs: {

  pname = "sm64ap";
  version = "0-unstable-2026-07-27";

  src = fetchFromGitHub {
    owner = "N00byKing";
    repo = "sm64ex";
    rev = "d73bce2e046a87d3ce1e4ae5fb1979fb290cc684";
    hash = "sha256-wCUfHSSGDn40/NGl1FuBBlqNVPn1HLSkx/VEIi/bna8=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    hexdump
    pkg-config
    python3
  ];

  buildInputs = [
    apcpp
    audiofile
    ixwebsocket
    libGL
    SDL2
    zlib
  ];

  env.APCPP_LD_PATH = "${apcpp}/lib";

  makeFlags = [
    "VERSION=${region}"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "OSX_BUILD=1"
  ++ lib.optional bettercamera "BETTERCAMERA=1"
  ++ lib.optional nodrawingdistance "NODRAWINGDISTANCE=1"
  ++ lib.optional texture_fix "TEXTURE_FIX=1";

  patches = [
    # Adds the missing help options that are required to connect to an Archipelago room
    ./add-missing-help-options-to-cli.patch
    # Changes the Makefile to use the system version of apcpp if available
    ./prefer-system-version-of-apcpp.patch
  ]
  ++ lib.optional _60fps (fetchpatch {
    # Allows the game to be rendered at 60 FPS instead of 30 FPS by interpolation (game logic still runs at 30 FPS)
    name = "60fps_ex.patch";
    url = "file://${finalAttrs.src}/enhancements/60fps_ex.patch";
    hash = "sha256-2V7WcZ8zG8Ef0bHmXVz2iaR48XRRDjTvynC4RPxMkcA=";
  })
  ++ lib.optional always-nonstop (fetchpatch {
    # Allows Mario to stay within the level after collecting a star
    name = "nonstop_mode_always_enabled.patch";
    url = "file://${finalAttrs.src}/enhancements/nonstop_mode_always_enabled.patch";
    hash = "sha256-s9V8UeIcjNyczfNPmgawgCmKJUkdCItSEr1cQ3ZyX/Q=";
  })
  ++ lib.optional extended-moveset (fetchpatch {
    # Adds various new actions to Mario's moveset, including moves from Sunshine and Odyssey
    name = "Extended.Moveset.v1.03b.sm64ex_archipelago.patch";
    url = "file://${finalAttrs.src}/enhancements/Extended.Moveset.v1.03b.sm64ex_archipelago.patch";
    hash = "sha256-kvsVZu5sXRJpya2BcnJOA+sgORBL3jK6YiZf/Gt3LlA=";
  });

  postPatch = ''
    # Nix requires the real path to cmake, useful if you build with submodules
    substituteInPlace Makefile --replace-fail " cmake " " ${lib.getExe cmake} "
    # Use the sm64ap directory to save the preferences, for consistency
    substituteInPlace src/pc/platform.c --replace-fail 'SDL_GetPrefPath("", "sm64ex")' 'SDL_GetPrefPath("", "sm64ap")'
  '';

  preBuild = ''
    patchShebangs extract_assets.py
    ln -s ${baseRom} ./baserom.${region}.z64
  '';

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp "build/${region}_pc/sm64.${region}.f3dex2e" "$out/bin/sm64ap"

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/N00byKing/sm64ex";
    description = "Super Mario 64 PC Port for Archipelago";
    longDescription = ''
      Note that you must supply a baserom yourself to extract assets from.
      If you are not using an US baserom, you must overwrite the "region" attribute with either "eu" or "jp".
    '';
    mainProgram = "sm64ap";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.SchweGELBin ];
    platforms = lib.platforms.unix;
  };
})
