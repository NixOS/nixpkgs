{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  python3,
  pkg-config,
  audiofile,
  SDL2,
  libGL,
  openssl,
  hexdump,
  cmake,
  apcpp,
  zlib,
  ixwebsocket,
  sm64baserom,
  discord-rpc,
  region ? "us",
  _60fps ? true,
  extended-moveset ? false,
  nonstop ? false,
  bettercamera ? true,
  with-discord-rpc ? true,
  fix-textures ? true,
  no-drawing-distance ? true,
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

  patches = [
    ./fix-makefile.patch
  ]
  ++ lib.optionals _60fps [
    (fetchpatch {
      name = "60fps_ex.patch";
      url = "file://${finalAttrs.src}/enhancements/60fps_ex.patch";
      hash = "sha256-2V7WcZ8zG8Ef0bHmXVz2iaR48XRRDjTvynC4RPxMkcA=";
    })
  ]
  ++ lib.optionals extended-moveset [
    (fetchpatch {
      name = "Extended.Moveset.v1.03b.sm64ex_archipelago.patch";
      url = "file://${finalAttrs.src}/enhancements/Extended.Moveset.v1.03b.sm64ex_archipelago.patch";
      hash = "sha256-kvsVZu5sXRJpya2BcnJOA+sgORBL3jK6YiZf/Gt3LlA=";
    })
  ]
  ++ lib.optionals nonstop [
    (fetchpatch {
      name = "nonstop_mode_always_enabled.patch";
      url = "file://${finalAttrs.src}/enhancements/nonstop_mode_always_enabled.patch";
      hash = "sha256-s9V8UeIcjNyczfNPmgawgCmKJUkdCItSEr1cQ3ZyX/Q=";
    })
  ];

  dontConfigure = true;

  strictDeps = true;
  nativeBuildInputs = [
    python3
    pkg-config
    hexdump
    cmake
  ];

  buildInputs = [
    apcpp
    ixwebsocket
    zlib
    audiofile
    SDL2
    libGL
    openssl
  ]
  ++ lib.optionals with-discord-rpc [ discord-rpc ];

  makeFlags = [
    "VERSION=${region}"
  ]
  ++ lib.optionals bettercamera [ "BETTERCAMERA=1" ]
  ++ lib.optionals no-drawing-distance [ "NODRAWINGDISTANCE=1" ]
  ++ lib.optionals fix-textures [ "TEXTURE_FIX=1" ]
  ++ lib.optionals with-discord-rpc [ "DISCORDRPC=1" ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "OSX_BUILD=1" ];

  env = {
    DISCORDRPC_LD_PATH = "${discord-rpc}/lib";
    APCPP_LD_PATH = "${apcpp}/lib";
  };

  # We remove dependency of the git-submodule apcpp
  postPatch = ''
    patchShebangs extract_assets.py
  '';

  preBuild = ''
    ln -s ${baseRom} ./baserom.${region}.z64
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp build/${region}_pc/sm64.${region}.f3dex2e $out/bin/sm64ex

    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/N00byKing/sm64ex/tree/archipelago";
    description = "Fork of sm64ex adding a link to archipelago";
    longDescription = ''
      Note that you must supply a baserom yourself from which to extract assets.
      If you are not using a US baserom, you must overwrite the "region" attribute with either "eu" or "jp".
    '';
    mainProgram = "sm64ex";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      mysaa
    ];
    platforms = lib.platforms.unix;
  };
})
