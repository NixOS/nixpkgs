{
  lib,
  buildEnv,
  callPackage,
  makeWrapper,
}:

buildEnv {
  name = "flare-1.14";

  paths = [
    (callPackage ./engine.nix { })
    (callPackage ./game.nix { })
  ];

  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    mkdir -p $out/bin
    makeWrapper $out/games/flare $out/bin/flare --chdir "$out/share/games/flare"
  '';

  meta = with lib; {
    description = "Fantasy action RPG using the FLARE engine";
    mainProgram = "flare";
    homepage = "https://flarerpg.org/";
    maintainers = with maintainers; [
      aanderse
      McSinyx
    ];
    license = [
      licenses.gpl3
      licenses.cc-by-sa-30
    ];
    platforms = platforms.unix;
  };
}
