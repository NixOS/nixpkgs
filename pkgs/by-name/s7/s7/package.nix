{ lib
, fetchFromGitLab
, stdenv
, notcurses
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "s7";
  version = "0-unstable-2024-07-12";

  src = fetchFromGitLab {
    domain = "cm-gitlab.stanford.edu";
    owner = "bil";
    repo = "s7";
    rev = "e4f8b1820aae3ce1551805f2e80d5e4913cfa2c3";
    hash = "sha256-MjCSYckvN6+4GH8iXi7bB7ncpHXY76sKGyB1OzH5M1A=";
  };

  nativeBuildInputs = [
    notcurses
  ];

  buildPhase = ''
    runHook preBuild

    gcc s7.c \
        -o s7-nrepl \
        -O2 \
        -I. \
        -Wl,-export-dynamic \
        -lm \
        -ldl \
        -DWITH_MAIN \
        -DWITH_NOTCURSES \
        -lnotcurses-core

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./s7-nrepl $out/bin/
    ln -s $out/bin/s7-nrepl $out/bin/s7

    mkdir -p $out/lib
    cp ./s7.c ./s7.h $out/lib/

    runHook postInstall
  '';

  meta = {
    description = "Scheme interpreter intended as an extension language for other applications";
    longDescription = ''
       s7 is a Scheme interpreter intended as an extension language for other
       applications. It exists as just two files, s7.c and s7.h, that want
       only to disappear into someone else's source tree. There are no
       libraries, no run-time init files, and no configuration scripts. It can
       be built as a stand-alone interpreter.
    '';
    homepage = "https://ccrma.stanford.edu/software/s7/";
    license = lib.licenses.bsd0;
    maintainers = [];
    mainProgram = "s7";
    platforms = lib.platforms.linux;
  };
})
