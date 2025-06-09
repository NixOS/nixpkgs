{
  lib,
  stdenv,
  fetchFromSourcehut,
  makeBinaryWrapper,
  curlMinimal,
  mandoc,
  ncurses,
  nim,
  pandoc,
  pkg-config,
  brotli,
  zlib,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "chawan";
  version = "0-unstable-2025-05-25";

  src = fetchFromSourcehut {
    owner = "~bptato";
    repo = "chawan";
    rev = "e571c8b1ede3a3c6dc4a5a4d0c6c8f48473076d2";
    hash = "sha256-OBXc4jnB5Y+KXO9J7P1Z2HXkNCS+xnG+IGWw8wb66J8=";
  };

  patches = [ ./mancha-augment-path.diff ];

  # Include chawan's man pages in mancha's search path
  postPatch = ''
    # As we need the $out reference, we can't use `replaceVars` here.
    substituteInPlace adapter/protocol/man.nim \
      --replace-fail '@out@' "$out"
  '';

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optional stdenv.cc.isClang "-Wno-error=implicit-function-declaration"
  );

  nativeBuildInputs = [
    makeBinaryWrapper
    nim
    pandoc
    pkg-config
    brotli
  ];

  buildInputs = [
    curlMinimal
    ncurses
    zlib
  ];

  buildFlags = [
    "all"
    "manpage"
  ];
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
    maintainers = with lib.maintainers; [ ];
    mainProgram = "cha";
  };
}
