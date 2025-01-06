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
    rev = "1e6e1596771183d9bb90bcf152d6bc2055219a7e";
    hash = "sha256-5XuiYkFe+QvVBRIXRieKoE0zbISMvU1iLgEfkw6GnlE=";
  };

  patches = [
    ./cdecl-2.5-lex.patch
    # when `USE_READLINE` is enabled, this option will not be present
    ./test_remove_interactive_line.patch
  ];

  prePatch = ''
    substituteInPlace cdecl.c \
      --replace 'getline' 'cdecl_getline'
  '';

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
