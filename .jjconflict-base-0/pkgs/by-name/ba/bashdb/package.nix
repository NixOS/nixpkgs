{
  lib,
  stdenv,

  fetchFromGitHub,

  autoreconfHook,
  texinfo,
  perl,

  python3,
  bash,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bashdb";
  version = "5.2-1.2.0";

  src = fetchFromGitHub {
    owner = "Trepan-Debuggers";
    repo = "bashdb";
    tag = finalAttrs.version;
    sha256 = "sha256-cbrBRP/NT3pUwT9KPpS3DxzrDhY2PGmLO/l+jKAbI68=";
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
    bash
  ];

  configureFlags = [
    # wants to point where bash expects dbg-main
    # for now point to self
    "--with-dbg-main=${placeholder "out"}/share/bashdb/bashdb-main.inc"
  ];

  passthru.updateScript = nix-update-script { };

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
    platforms = lib.platforms.unix;
  };
})
