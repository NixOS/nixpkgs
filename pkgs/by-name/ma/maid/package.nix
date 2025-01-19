{
  bundlerApp,
  bundlerUpdateScript,
  callPackage,
  lib,
}:

bundlerApp {
  pname = "maid";
  gemdir = ./.;
  exes = [ "maid" ];

  passthru.updateScript = bundlerUpdateScript "maid";

  passthru.tests.run = callPackage ./test.nix { };

  meta = {
    description = "Rule-based file mover and cleaner in Ruby";
    homepage = "https://github.com/maid/maid";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ alanpearce ];
    platforms = lib.platforms.unix;
  };
}
