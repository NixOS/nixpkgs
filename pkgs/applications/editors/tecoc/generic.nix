{ pname
, version
, src
, passthru
, meta
}:

{ lib
, stdenv
, ncurses
}:

stdenv.mkDerivation {
  inherit pname version src passthru meta;

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
}
