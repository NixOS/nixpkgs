{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  replaceVars,
  bison,
  texinfo,
  bintools,
  bzip2,
  coreutils,
  file,
  findutils,
  gdb,
  gmp,
  gnugrep,
  gzip,
  less,
  lzo,
  more,
  mpfr,
  ncurses,
  procps,
  snappy,
  xz,
  zlib,
  zstd,
  nix-update-script,
}:

let
  gdbVersion = "16.2";
  gdbSrc = fetchurl {
    url = "mirror://gnu/gdb/gdb-${gdbVersion}.tar.gz";
    hash = "sha256-vcHaSgMygKx1Ln00sEGO+qRb7QkyNcuI5i6pYXUqN/g=";
  };

  crashPathsPatch = replaceVars ./crash-replace-hardcoded-paths.patch {
    bunzip2 = lib.getExe' bzip2 "bunzip2";
    cat = lib.getExe' coreutils "cat";
    echo = lib.getExe' coreutils "echo";
    file = lib.getExe file;
    find = lib.getExe findutils;
    gdb = lib.getExe gdb;
    grep = lib.getExe gnugrep;
    gunzip = lib.getExe' gzip "gunzip";
    gzip = lib.getExe gzip;
    less = lib.getExe less;
    ls = lib.getExe' coreutils "ls";
    more = lib.getExe more;
    nm = lib.getExe' bintools "nm";
    ps = lib.getExe' procps "ps";
    strings = lib.getExe' bintools "strings";
    tty = lib.getExe' coreutils "tty";
    unxz = lib.getExe' xz "unxz";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "crash";
  version = "9.0.1";

  outputs = [
    "bin"
    "man"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "crash-utility";
    repo = "crash";
    tag = finalAttrs.version;
    hash = "sha256-5+0+nVj+8S3FS/CRwHMDIhm2n18xDubN+UVCCqzDPbE=";
  };

  patches = [
    crashPathsPatch
  ];

  postPatch = ''
    substituteInPlace gdb-${gdbVersion}.patch --replace-fail "/bin/cat" "cat"
    substituteInPlace Makefile --replace-fail "/usr/bin/install" "install"
    ln -s ${gdbSrc} ${builtins.baseNameOf gdbSrc.url}
  '';

  strictDeps = true;

  nativeBuildInputs = [
    bison
    texinfo
  ];

  buildInputs = [
    gmp
    lzo
    mpfr
    ncurses
    snappy
    zlib
    zstd
  ];

  enableParallelBuilding = true;

  buildFlags = [
    "lzo"
    "snappy"
    "zstd"
  ];

  enableParallelInstalling = true;

  installFlags = [
    "INSTALLDIR=${placeholder "bin"}/bin"
  ];

  postInstall = ''
    mkdir -p "$man/share/man/man8"
    cp crash.8 "$man/share/man/man8"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linux kernel crash utility";
    homepage = "https://crash-utility.github.io/";
    downloadPage = "https://github.com/crash-utility/crash/releases/${finalAttrs.version}";
    changelog = "https://crash-utility.github.io/changelog/ChangeLog-${finalAttrs.version}.txt";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ al3xtjames ];
    mainProgram = "crash";
    platforms = lib.platforms.linux;
  };
})
