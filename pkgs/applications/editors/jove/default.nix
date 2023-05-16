{ lib
, stdenv
, fetchFromGitHub
, groff
, makeWrapper
, ncurses
<<<<<<< HEAD
, runtimeShell
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jove";
<<<<<<< HEAD
  version = "4.17.5.3";
=======
  version = "4.17.4.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jonmacs";
    repo = "jove";
    rev = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-ZBq2zCml637p9VgedpOrUn2jSc5L0pthdgRS7YsB3zs=";
=======
    sha256 = "sha256-Lo5S3t4vewkpoihVdxa3yRrEzNWeNLHCZHXiLCxOH5o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    groff
    ncurses
  ];

<<<<<<< HEAD
  postPatch = ''
    patchShebangs testbuild.sh testmailer.sh teachjove jmake.sh
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  dontConfigure = true;

  preBuild = ''
    makeFlagsArray+=(SYSDEFS="-DSYSVR4 -D_XOPEN_SOURCE=500" \
<<<<<<< HEAD
      JTMPDIR=$TMPDIR
      TERMCAPLIB=-lncurses \
      SHELL=${runtimeShell} \
      DFLTSHELL=${runtimeShell} \
      JOVEHOME=${placeholder "out"})
=======
      TERMCAPLIB=-lncurses JOVEHOME=${placeholder "out"})
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  postInstall = ''
    wrapProgram $out/bin/teachjove \
      --prefix PATH ":" "$out/bin"
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/jonmacs/jove";
    description = "Jonathan's Own Version of Emacs";
    changelog = "https://github.com/jonmacs/jove/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    homepage = "https://github.com/jonmacs/jove";
    description = "Jonathan's Own Version of Emacs";
    changelog = "https://github.com/jonmacs/jove/releases/tag/${finalAttrs.version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # never built on Hydra: https://hydra.nixos.org/job/nixpkgs/trunk/jove.x86_64-darwin
    broken = stdenv.isDarwin;
  };
})
