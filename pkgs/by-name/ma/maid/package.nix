{
  bundlerApp,
  bundlerUpdateScript,
  callPackage,
  lib,
}:

bundlerApp rec {
  pname = "maid";
  gemdir = ./.;
  exes = [ "maid" ];

  passthru.updateScript = bundlerUpdateScript pname;

  passthru.tests.run = callPackage ./test.nix { };

<<<<<<< HEAD
  meta = {
    description = "Rule-based file mover and cleaner in Ruby";
    homepage = "https://github.com/maid/maid";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ alanpearce ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Rule-based file mover and cleaner in Ruby";
    homepage = "https://github.com/maid/maid";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ alanpearce ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
