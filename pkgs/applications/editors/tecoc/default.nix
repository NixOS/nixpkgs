{ stdenv
, lib
, fetchFromGitHub
, ncurses
<<<<<<< HEAD
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tecoc";
  version = "unstable-2023-04-21";
=======
}:

stdenv.mkDerivation rec {
  pname = "tecoc";
  version = "unstable-2020-11-03";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "blakemcbride";
    repo = "TECOC";
<<<<<<< HEAD
    rev = "021d1d15242b9d6c84d70c9ffcf1871793898f0a";
    hash = "sha256-VGIO+uiAZkdzLYmJztmnKTS4HDIVow4AimaneHj7E1M=";
=======
    rev = "79fcb6cfd6c5f9759f6ec46aeaf86d5806b13a0b";
    sha256 = "sha256-JooLvoh9CxLHLOXXxE7zA7R9yglr9BGUwX4nrw2/vIw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ ncurses ];

  makefile = if stdenv.hostPlatform.isDarwin
             then "makefile.osx"
             else if stdenv.hostPlatform.isFreeBSD
             then "makefile.bsd"
             else if stdenv.hostPlatform.isOpenBSD
             then "makefile.bsd"
             else if stdenv.hostPlatform.isWindows
             then "makefile.win"
             else "makefile.linux"; # I think Linux is a safe default...

<<<<<<< HEAD
  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" "-C src/" ];

  installPhase = ''
    runHook preInstall

    install -d $out/bin $out/share/doc/tecoc $out/lib/teco/macros
    install -m755 src/tecoc $out/bin
    install -m644 src/aaout.txt doc/* $out/share/doc/tecoc
    install -m644 lib/* lib2/* $out/lib/teco/macros

    runHook postInstall
  '';

  postFixup = ''
    pushd $out/bin
    ln -s tecoc Make
    ln -s tecoc mung
    ln -s tecoc teco
    ln -s tecoc Inspect
    popd
  '';

  passthru.updateScript = unstableGitUpdater {
    url = finalAttrs.meta.homepage;
  };

  meta = {
    homepage = "https://github.com/blakemcbride/TECOC";
=======
  makeFlags = [ "CC=${stdenv.cc}/bin/cc" "-C src/" ];

  preInstall = ''
    install -d $out/bin $out/share/doc/${pname}-${version} $out/lib/teco/macros
  '';

  installPhase = ''
    runHook preInstall
    install -m755 src/tecoc $out/bin
    install -m644 src/aaout.txt doc/* $out/share/doc/${pname}-${version}
    install -m644 lib/* lib2/* $out/lib/teco/macros
    runHook postInstall
  '';

  postInstall = ''
    (cd $out/bin
     ln -s tecoc Make
     ln -s tecoc mung
     ln -s tecoc teco
     ln -s tecoc Inspect )
  '';

  meta = with lib; {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "A clone of the good old TECO editor";
    longDescription = ''
      For those who don't know: TECO is the acronym of Tape Editor and COrrector
      (because it was a paper tape edition tool in its debut days). Now the
      acronym follows after Text Editor and Corrector, or Text Editor
      Character-Oriented.

      TECO is a character-oriented text editor, originally developed by Dan
      Murphy at MIT circa 1962. It is also a Turing-complete imperative
      interpreted programming language for text manipulation, done via
      user-loaded sets of macros. In fact, the venerable Emacs was born as a set
      of Editor MACroS for TECO.

      TECOC is a portable C implementation of TECO-11.
    '';
<<<<<<< HEAD
    license = {
      url = "https://github.com/blakemcbride/TECOC/tree/master/doc/readme-1st.txt";
    };
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
=======
    homepage = "https://github.com/blakemcbride/TECOC";
    license = {
      url = "https://github.com/blakemcbride/TECOC/tree/master/doc/readme-1st.txt";
    };
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
