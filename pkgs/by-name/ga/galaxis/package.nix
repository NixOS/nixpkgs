{
  lib,
  asciidoctor,
  fetchFromGitLab,
  ncurses,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "galaxis";
  version = "1.11";

  src = fetchFromGitLab {
    owner = "esr";
    repo = "galaxis";
    rev = finalAttrs.version;
    hash = "sha256-fSzifGoSdWyFGt99slzAsqCMDoeLbBqQGXujX8QAfGc=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    asciidoctor
  ];

  buildInputs = [
    ncurses
  ];

  strictDeps = true;

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "galaxis"
    "galaxis.6"
  ];

  postPatch = ''
    sed -i -E '/[[:space:]]*xmlto/ s|xmlto|xmlto --skip-validation|' Makefile
  '';

  # This is better than sed-patch the Makefile
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $man/share/man/man6
    install -Dm755 galaxis -t $out/bin/
    install -Dm644 galaxis.6 -t $man/share/man/man6
    runHook postInstall
  '';

  meta = {
    description = "Rescue lifeboats lost in interstellar space";
    longDescription = ''
      Lifeboats from a crippled interstellar liner are adrift in a starfield. To
      find them, you can place probes that look in all eight compass directions
      and tell you how many lifeboats they see. If you drop a probe directly on
      a lifeboat it will be revealed immediately. Your objective: find the
      lifeboats as quickly as possible, before the stranded passengers run out
      of oxygen!

      This is a UNIX-hosted, curses-based clone of the nifty little Macintosh
      freeware game Galaxis. It doesn't have the super-simple, point-and-click
      interface of the original, but compensates by automating away some of the
      game's simpler deductions.
    '';
    homepage = "http://catb.org/~esr/galaxis/";
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "galaxis";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
