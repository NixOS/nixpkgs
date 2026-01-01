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

<<<<<<< HEAD
  meta = {
    description = "Fantasy action RPG using the FLARE engine";
    mainProgram = "flare";
    homepage = "https://flarerpg.org/";
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Fantasy action RPG using the FLARE engine";
    mainProgram = "flare";
    homepage = "https://flarerpg.org/";
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      aanderse
      McSinyx
    ];
    license = [
<<<<<<< HEAD
      lib.licenses.gpl3
      lib.licenses.cc-by-sa-30
    ];
    platforms = lib.platforms.unix;
=======
      licenses.gpl3
      licenses.cc-by-sa-30
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
