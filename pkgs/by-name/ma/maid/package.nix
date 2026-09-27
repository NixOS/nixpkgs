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

  meta = {
    description = "Rule-based file mover and cleaner in Ruby";
    homepage = "https://github.com/maid/maid";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ alinnow ];
    platforms = lib.platforms.unix;
  };
}
