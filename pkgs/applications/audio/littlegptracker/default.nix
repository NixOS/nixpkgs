{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  python3,
  jack2,
  Foundation,
  alsa-lib,
  pkg-config,
}:
let
  python = python3.withPackages (ps: with ps; [ pillow ]);
  platform = if stdenv.hostPlatform.isDarwin then "OSX" else "X64";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "littlegptracker";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "djdiskmachine";
    repo = "littlegptracker";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-1uXC5nJ63YguQuNIkuK0yx9lmrMBqw0WdlmCV8o11cE=";
  };

  nativeBuildInputs = [
    pkg-config
    python
  ];
  buildInputs =
    [ SDL2 ]
    ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform alsa-lib) alsa-lib
    ++ lib.optional stdenv.hostPlatform.isDarwin Foundation
    ++ lib.optional stdenv.hostPlatform.isLinux jack2;

  preBuild = ''
    cd projects
  '';

  makeFlags = [
    "CXX=${stdenv.cc.targetPrefix}c++"
    "PLATFORM=${platform}"
  ];

  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-framework Foundation";

  installPhase =
    let
      extension = if stdenv.hostPlatform.isDarwin then "app" else "x64";
    in
    ''
      runHook preInstall
      install -Dm555 lgpt.${extension} $out/lib/lgpt/lgpt
      install -Dm444 resources/${platform}/{config,mapping}.xml $out/lib/lgpt/
      mkdir -p $out/bin
      ln -s $out/lib/lgpt/lgpt $out/bin/
      runHook postInstall
    '';

  meta = {
    description = "Music tracker optimised to run on portable game consoles";
    longDescription = ''
      Little Piggy Tracker (f.k.a 'LittleGPTracker') is a music tracker optimised to run on portable game consoles.
      It is currently running on Windows, MacOS (intel/arm) & Linux, PSP, Miyoo Mini, and a collection of other retro gaming handhelds.
      It implements the user interface of littlesounddj and precedes M8 tracker, two popular trackers greatly loved in the tracker community.
    '';
    homepage = "https://github.com/djdiskmachine/LittleGPTracker";
    downloadPage = "https://github.com/djdiskmachine/LittleGPTracker/releases";
    mainProgram = "lgpt";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;

    # https://github.com/NixOS/nixpkgs/pull/352617#issuecomment-2495663097
    broken = stdenv.hostPlatform.isDarwin;
  };
})
