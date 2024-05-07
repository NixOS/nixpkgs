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
  pname = "cdecl";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "ridiculousfish";
    repo = "cdecl-blocks";
    # github repo has no tag, but the 2.5 version match this commit
    rev = "cb130ea7e61df5b6fa1e84f996e3f04e21a0181c";
    hash = "sha256-lErAxTpPIT49QdOpdjM9e3Qyaajzc+iwv27B3XUFUuE=";
  };

  buildInputs = [
    bison
    flex
    readline
    ncurses
  ];

  NIX_CFLAGS_COMPILE = "-DBSD -DUSE_READLINE -std=gnu89";
  NIX_LDFLAGS = "-lreadline";

  makeFlags = [
    "CC=${stdenv.cc}/bin/cc" # otherwise fails on x86_64-darwin
    "PREFIX=${placeholder "out"}"
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/man1"
    "CATDIR=${placeholder "out"}/cat1"
  ];

  patches = [ ./cdecl-2.5-lex.patch ];
  prePatch = ''
    substituteInPlace cdecl.c --replace 'getline' 'cdecl_getline'
  '';

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
