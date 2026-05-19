{
  lib,
  buildEnv,
  callPackage,
  makeWrapper,
  stdenv,
  desktopToDarwinBundle,
}:

let
  common = import ./common.nix { inherit lib; };
in
buildEnv {
  pname = "flare";
  inherit (common) version;

  paths = [
    (callPackage ./engine.nix { })
    (callPackage ./game.nix { })
  ];

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  postBuild = ''
    mkdir -p $out/bin
    makeWrapper $out/games/flare $out/bin/flare --chdir "$out/share/games/flare"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    convertDesktopFiles "$out"
  '';

  meta = {
    description = "Fantasy action RPG using the FLARE engine";
    mainProgram = "flare";
    homepage = "https://flarerpg.org/";
    license = [
      lib.licenses.gpl3
      lib.licenses.cc-by-sa-30
    ];
    platforms = lib.platforms.unix;
    inherit (common) maintainers;
  };
}
