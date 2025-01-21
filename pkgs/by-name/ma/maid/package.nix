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

  meta = with lib; {
    description = "Rule-based file mover and cleaner in Ruby";
    homepage = "https://github.com/maid/maid";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ alanpearce ];
    platforms = platforms.unix;
  };
}
