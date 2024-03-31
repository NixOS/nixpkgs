{ lib
, stdenv
, fetchFromSourcehut
, makeBinaryWrapper
, curlMinimal
, mandoc
, ncurses
, nim
, pandoc
, perl
, pkg-config
, zlib
}:

stdenv.mkDerivation {
  pname = "chawan";
  version = "0-unstable-2024-03-01";

  src = fetchFromSourcehut {
    owner = "~bptato";
    repo = "chawan";
    rev = "87ba9a87be15abbe06837f1519cfb76f4bf759f3";
    hash = "sha256-Xs+Mxe5/uoxPMf4FuelpO+bRJ1KdfASVI7rWqtboJZw=";
    fetchSubmodules = true;
  };

  patches = [
    # Include chawan's man pages in mancha's search path
    ./mancha-augment-path.diff
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optional stdenv.cc.isClang "-Wno-error=implicit-function-declaration"
  );

  buildInputs = [ curlMinimal ncurses perl zlib ];
  nativeBuildInputs = [
    makeBinaryWrapper
    nim
    pandoc
    pkg-config
  ];

  postPatch = ''
    substituteInPlace adapter/protocol/man \
      --replace-fail "OUT" $out
  '';

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

  meta = {
    description = "Lightweight and featureful terminal web browser";
    homepage = "https://sr.ht/~bptato/chawan/";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ jtbx ];
    mainProgram = "cha";
    broken = stdenv.isDarwin; # pending PR #292043
  };
}
