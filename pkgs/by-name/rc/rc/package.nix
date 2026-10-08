{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  pkgsStatic,
  rc,
  byacc,
  ed,
  ncurses,
  readline,
  editline,
  installShellFiles,
  historySupport ? true,
  readlineSupport ? true,
  editlineSupport ? false,
  lineEditingLibrary ? if stdenv.hostPlatform.isDarwin then "null" else "readline",
}:

assert lib.elem lineEditingLibrary [
  "null"
  "edit"
  "editline"
  "readline"
  "vrl"
];
assert
  !(lib.elem lineEditingLibrary [
    "edit"
    "vrl"
  ]); # broken
assert (lineEditingLibrary == "readline") -> readlineSupport;
assert (lineEditingLibrary == "editline") -> editlineSupport;
stdenv.mkDerivation (finalAttrs: {
  pname = "rc";
  version = "1.7.4-unstable-2025-10-01";

  src = fetchFromGitHub {
    owner = "rakitzis";
    repo = "rc";
    rev = "2bab312ea11cb77d2654a731357842971c0b5d18";
    hash = "sha256-ViyO3i7P2RU5HZvbenANOT1WTF7JCLexeqeHPUT8PCQ=";
  };

  outputs = [
    "out"
    "man"
  ];

  postPatch = ''
    sed -i '/main.o: version.h/ d' Makefile
    cat << EOF > version.h
    #define VERSION "1.7.4+${finalAttrs.src.rev}"
    EOF
  '';

  nativeBuildInputs = [
    byacc
    ed
    installShellFiles
  ];

  buildInputs = [
    ncurses
  ]
  ++ lib.optional readlineSupport readline
  ++ lib.optional editlineSupport editline;

  strictDeps = true;

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PREFIX=${placeholder "out"}"
    "MANPREFIX=${placeholder "man"}/share/man"
    "CPPFLAGS=\"-DSIGCLD=SIGCHLD\""
    "EDIT=${lineEditingLibrary}"
  ]
  # Required to fix static build, harmless for dynamic builds.
  ++ lib.optional (lineEditingLibrary == "readline") "LDLIBS=-lncurses";

  buildFlags = [
    "all"
  ]
  ++ lib.optionals historySupport [
    "history"
  ];

  postInstall = lib.optionalString historySupport ''
    installManPage history.1
  '';

  passthru = {
    shellPath = "/bin/rc";
    tests = {
      static = pkgsStatic.rc;
      readline = lib.optionalDrvAttr (!stdenv.hostPlatform.isDarwin) (
        rc.override {
          readlineSupport = true;
          lineEditingLibrary = "readline";
        }
      );
      editline = lib.optionalDrvAttr (!stdenv.hostPlatform.isDarwin) (
        rc.override {
          editlineSupport = true;
          lineEditingLibrary = "editline";
        }
      );
    };
  };

  meta = {
    homepage = "https://github.com/rakitzis/rc";
    description = "Plan 9 shell";
    license = lib.licenses.zlib;
    mainProgram = "rc";
    maintainers = with lib.maintainers; [ ramkromberg ];
    platforms = lib.platforms.unix;
  };
})
