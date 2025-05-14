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
  zlib,
  unstableGitUpdater,
  replaceVars,
}:

stdenv.mkDerivation {
  pname = "chawan";
  version = "0-unstable-2025-04-18";

  src = fetchFromSourcehut {
    owner = "~bptato";
    repo = "chawan";
    rev = "656092f399d36c13a551b4a2474c8aded3388b1a";
    hash = "sha256-GYCmRIswHFM+VehBlf8NSAt0ewrl7SVD0y9lLhFYkvo=";
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
    maintainers = with lib.maintainers; [ jtbx ];
    mainProgram = "cha";
  };
}
