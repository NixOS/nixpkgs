{
  lib,
  stdenv,

  fetchFromGitHub,

  autoreconfHook,
  texinfo,
  perl,

  python3,
}:

stdenv.mkDerivation {
  pname = "bashdb";
  version = "5.2-1.1.2-unstable-2025-06-07";

  src = fetchFromGitHub {
    owner = "Trepan-Debuggers";
    repo = "bashdb";
    rev = "7d0f9751e04fa54f48f0ab4be32ecb8030a4315d";
    sha256 = "sha256-fwxmlFC66Lv+zD632s9a44I9IEQ/82caKnQ44pdVes4=";
  };

  patches = [
    ./bash-5-or-greater.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    texinfo # maninfo
    perl # pod2man
  ];

  buildInputs = [
    # used at runtime by term-highlight.py
    (python3.withPackages (ps: [ ps.pygments ]))
  ];

  configureFlags = [
    # wants to point where bash expects dbg-main
    # for now point to self
    "--with-dbg-main=${placeholder "out"}/share/bashdb/bashdb-main.inc"
  ];

  meta = {
    homepage = "https://bashdb.sourceforge.net/";
    description = "A gdb-like debugger for bash";
    longDescription = ''
      The Bash Debugger Project is a source-code debugger for bash that follows
      the gdb command syntax.
    '';
    license = lib.licenses.gpl2Plus;
    mainProgram = "bashdb";
    maintainers = with lib.maintainers; [
      jk
    ];
    platforms = lib.platforms.linux;
  };
}
