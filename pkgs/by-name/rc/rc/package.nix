{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  pkgsStatic,
  byacc,
  ed,
  ncurses,
  readline,
  installShellFiles,
  historySupport ? true,
  readlineSupport ? true,
  lineEditingLibrary ?
    if (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isStatic) then "null" else "readline",
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
    "editline"
    "vrl"
  ]); # broken
assert (lineEditingLibrary == "readline") -> readlineSupport;
stdenv.mkDerivation (finalAttrs: {
  pname = "rc";
  version = "unstable-2025-10-01";

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

  # TODO: think on a less ugly fixup
  postPatch = ''
    ed -v -s Makefile << EOS
    # - remove reference to now-inexistent git index file
    /version.h:/ s| .git/index||
    # - manually insert the git revision string
    /v=/ c
    ${"\t"}v=${builtins.substring 0 7 finalAttrs.src.rev}
    .
    /\.git\/index:/ d
    w
    q
    EOS
  '';

  nativeBuildInputs = [
    byacc
    ed
    installShellFiles
  ];

  buildInputs = [
    ncurses
  ]
  ++ lib.optionals readlineSupport [
    readline
  ];

  strictDeps = true;

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PREFIX=${placeholder "out"}"
    "MANPREFIX=${placeholder "man"}/share/man"
    "CPPFLAGS=\"-DSIGCLD=SIGCHLD\""
    "EDIT=${lineEditingLibrary}"
  ];

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
    tests.static = pkgsStatic.rc;
  };

  meta = {
    homepage = "https://github.com/rakitzis/rc";
    description = "Plan 9 shell";
    license = [ lib.licenses.zlib ];
    mainProgram = "rc";
    maintainers = with lib.maintainers; [ ramkromberg ];
    platforms = lib.platforms.unix;
  };
})
