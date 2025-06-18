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
  version = "0-unstable-2025-06-14";

  src = fetchFromSourcehut {
    owner = "~bptato";
    repo = "chawan";
    rev = "288896b6f3da9bb6e4e24190d4163e031f8a2751";
    hash = "sha256-/8pp1E4YAXXh8ORRHseIe48BIG14u8gNkmotA+CXPYY=";
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
