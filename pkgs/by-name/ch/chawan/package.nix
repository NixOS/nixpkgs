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
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chawan";
  version = "0.2.1";

  src = fetchFromSourcehut {
    owner = "~bptato";
    repo = "chawan";
    rev = "v${finalAttrs.version}";
    hash = "sha256-n0hyAT6XuNJTpjLlYiiDER1xrz8nwT+Q2kSkg28Y8zE=";
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

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Lightweight and featureful terminal web browser";
    homepage = "https://sr.ht/~bptato/chawan/";
    changelog = "https://git.sr.ht/~bptato/chawan/refs/v${finalAttrs.version}";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "cha";
  };
})
