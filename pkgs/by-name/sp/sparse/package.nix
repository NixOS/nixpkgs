{
  callPackage,
  fetchgit,
  lib,
  stdenv,
  gtk3,
  pkg-config,
  libxml2,
  llvm,
  perl,
  sqlite,
}:

let
  GCC_BASE = "${stdenv.cc.cc}/lib/gcc/${stdenv.hostPlatform.uname.processor}-unknown-linux-gnu/${stdenv.cc.cc.version}";
in
stdenv.mkDerivation {
  pname = "sparse";
  version = "0.6.5-rc1-unstable-2025-12-18";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/devel/sparse/sparse.git";
    rev = "37156835e3d725b6d750f000be33ba3814bb2310";
    hash = "sha256-662n1ENn8ZsiBtSBx6Vr1MrRAwzvob0Y1ifnBVtfB5k=";
  };

  preConfigure = ''
    sed -i 's|"/usr/include"|"${stdenv.cc.libc.dev}/include"|' pre-process.c
    sed -i 's|qx(\$ccom -print-file-name=)|"${GCC_BASE}"|' cgcc
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk3
    libxml2
    llvm
    perl
    sqlite
  ];
  doCheck = true;
  buildFlags = [ "GCC_BASE:=${GCC_BASE}" ];

  # Test failures with "fortify3" on, such as:
  # +*** buffer overflow detected ***: terminated
  # +Aborted (core dumped)
  # error: Actual exit value does not match the expected one.
  # error: expected 0, got 134.
  # error: FAIL: test 'bool-float.c' failed
  hardeningDisable = [ "fortify3" ];

  passthru.tests = {
    simple-execution = callPackage ./tests.nix { };
  };

  meta = {
    description = "Semantic parser for C";
    homepage = "https://git.kernel.org/pub/scm/devel/sparse/sparse.git/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      thoughtpolice
      jkarlson
    ];
  };
}
