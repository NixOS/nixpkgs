{
  lib,
  buildEnv,
  callPackage,
  makeWrapper,
}:

buildEnv {
  pname = "flare";
  version = "1.14";

  paths = [
    (callPackage ./engine.nix { })
    (callPackage ./game.nix { })
  ];

  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    mkdir -p $out/bin
    makeWrapper $out/games/flare $out/bin/flare --chdir "$out/share/games/flare"
  '';

  meta = {
    description = "Fantasy action RPG using the FLARE engine";
    mainProgram = "flare";
    homepage = "https://flarerpg.org/";
    maintainers = with lib.maintainers; [
      aanderse
      McSinyx
    ];
    license = [
      lib.licenses.gpl3
      lib.licenses.cc-by-sa-30
    ];
    platforms = lib.platforms.unix;
  };
}
