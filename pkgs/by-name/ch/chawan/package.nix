{ lib
, stdenv
, fetchFromSourcehut
, makeBinaryWrapper
, curlMinimal
, mandoc
, ncurses
, nim
, pandoc
, pkg-config
, zlib
, unstableGitUpdater
, libseccomp
, replaceVars
}:

stdenv.mkDerivation {
  pname = "chawan";
  version = "0-unstable-2024-12-17";

  src = fetchFromSourcehut {
    owner = "~bptato";
    repo = "chawan";
    rev = "13f395f20bd786d6c055b59ad19e9018d85bc139";
    hash = "sha256-UnJi2HJQv6PCpBWLka9aIUMYjG0a+tgH6vM4ZZ9gi2E=";
    fetchSubmodules = true;
  };

  patches = [
    # Include chawan's man pages in mancha's search path
    (replaceVars ./mancha-augment-path.diff {
      out = placeholder "out";
    })
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optional stdenv.cc.isClang "-Wno-error=implicit-function-declaration"
  );

  nativeBuildInputs = [
    makeBinaryWrapper
    nim
    pandoc
    pkg-config
  ];

  buildInputs = [
    curlMinimal
    libseccomp
    ncurses
    zlib
  ];

  buildFlags = [ "all" "manpage" ];
  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX=/"
  ];

  postInstall =
  let
    makeWrapperArgs = ''
      --set MANCHA_CHA $out/bin/cha \
      --set MANCHA_MAN ${mandoc}/bin/man
    '';
  in
  ''
    wrapProgram $out/bin/cha ${makeWrapperArgs}
    wrapProgram $out/bin/mancha ${makeWrapperArgs}
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Lightweight and featureful terminal web browser";
    homepage = "https://sr.ht/~bptato/chawan/";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ jtbx ];
    mainProgram = "cha";
    broken = stdenv.hostPlatform.isDarwin; # pending PR #292043
  };
}
