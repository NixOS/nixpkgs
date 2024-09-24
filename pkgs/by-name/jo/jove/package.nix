{ lib
, stdenv
, fetchFromGitHub
, groff
, makeWrapper
, ncurses
, runtimeShell
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jove";
  version = "4.17.5.3";

  src = fetchFromGitHub {
    owner = "jonmacs";
    repo = "jove";
    rev = finalAttrs.version;
    hash = "sha256-ZBq2zCml637p9VgedpOrUn2jSc5L0pthdgRS7YsB3zs=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    groff
    ncurses
  ];

  postPatch = ''
    patchShebangs testbuild.sh testmailer.sh teachjove jmake.sh
  '';

  dontConfigure = true;

  preBuild = ''
    makeFlagsArray+=(SYSDEFS="-DSYSVR4 -D_XOPEN_SOURCE=500" \
      JTMPDIR=$TMPDIR
      TERMCAPLIB=-lncurses \
      SHELL=${runtimeShell} \
      DFLTSHELL=${runtimeShell} \
      JOVEHOME=${placeholder "out"})
  '';

  postInstall = ''
    wrapProgram $out/bin/teachjove \
      --prefix PATH ":" "$out/bin"
  '';

  meta = {
    homepage = "https://github.com/jonmacs/jove";
    description = "Jonathan's Own Version of Emacs";
    changelog = "https://github.com/jonmacs/jove/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
    # never built on Hydra: https://hydra.nixos.org/job/nixpkgs/trunk/jove.x86_64-darwin
    broken = stdenv.hostPlatform.isDarwin;
  };
})
