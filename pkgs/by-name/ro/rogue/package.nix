{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rogue";
  # nixpkgs-update: no auto update
  # rogueforge.net, the upstream, is gone and 5.4.5 was its last release
  version = "5.4.5";

  src = fetchurl {
    urls = [
      "https://src.fedoraproject.org/repo/pkgs/rogue/rogue${finalAttrs.version}a-src.tar.gz/6c1470dab0bdc987d459ae1f0f59e622/rogue${finalAttrs.version}a-src.tar.gz"
      "https://web.archive.org/web/20230819173224/http://rogue.rogueforge.net/files/rogue5.4/rogue${finalAttrs.version}a-src.tar.gz"
    ];
    hash = "sha256-bTjjj5WikeeFQWIifn0t4otR372nYXB6GQwtf2Kc9KY=";
  };

  patches = [
    # Restoring a saved game crashes: the writers append a stray -1 after the string index
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/rogue/raw/8451c1f42fcd33c391f60464a2d37fb39bb458a3/f/rogue-5.4.5-writesave.patch";
      extraPrefix = "";
      hash = "sha256-MdajbUSAnuDaE8xvkPkdKG07jk3bupc1fWXszeUxuKQ=";
    })
    # Make Backspace erase in prompts
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/rogue/raw/8451c1f42fcd33c391f60464a2d37fb39bb458a3/f/rogue-5.4.5-backspace.patch";
      hash = "sha256-eicpUh15iT5Fpcokm0Rer7ahR9T+Y2hQc1Jp4Xm2DTg=";
    })
    # Build with ncurses 6, whose structures are opaque
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/rogue/raw/8451c1f42fcd33c391f60464a2d37fb39bb458a3/f/rogue-5.4.5-ncurses.patch";
      hash = "sha256-wZARWJhZ2iW3H7LJYD2GGROaEgC8rLA0HZwVKGsDm7M=";
    })
  ];

  buildInputs = [ ncurses ];

  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  meta = {
    description = "Final version of the original Rogue game developed for the UNIX operating system";
    mainProgram = "rogue";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ iedame ];
  };
})
