{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
  readline,
  ncurses,
}:

stdenv.mkDerivation {
  pname = "cdecl-blocks";
  version = "2.5-unstable-2024-05-07";

  src = fetchFromGitHub {
    owner = "ridiculousfish";
    repo = "cdecl-blocks";
    rev = "0fdb58f78bdc96409b07fa2945673e2d80c74557";
    hash = "sha256-gR+a7J20oZMnHkM1LNwQOQaUt1BO84K5CzvaASHAnRE=";
  };

  patches = [ ./test_remove_interactive_line.patch ];

  strictDeps = true;

  nativeBuildInputs = [
    bison
    flex
  ];

  buildInputs = [
    readline
    ncurses
  ];

  env = {
    NIX_CFLAGS_COMPILE = toString (
      [
        "-DBSD"
        "-DUSE_READLINE"
      ]
      ++ lib.optionals stdenv.cc.isClang [
        "-Wno-error=int-conversion"
        "-Wno-error=incompatible-function-pointer-types"
      ]
    );
    NIX_LDFLAGS = "-lreadline";
  };

  makeFlags = [
    "CC=${lib.getExe stdenv.cc}"
    "PREFIX=${placeholder "out"}"
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/man1"
    "CATDIR=${placeholder "out"}/cat1"
  ];

  doCheck = true;
  checkTarget = "test";

  preInstall = ''
    mkdir -p $out/bin;
  '';

  meta = {
    description = "Translator English -- C/C++ declarations";
    homepage = "https://cdecl.org";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.unix;
    mainProgram = "cdecl";
  };
}
