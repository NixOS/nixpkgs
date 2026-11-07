{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  bison,
  flex,
  texinfo,
  ncurses,
  zlib,
  lzo,
  snappy,
  zstd,
  gmp,
  mpfr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crash-utility";
  version = "9.0.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "crash-utility";
    repo = "crash";
    tag = finalAttrs.version;
    hash = "sha256-6FxPBAFFTO3lZXYkp02Nj5HytGEcqswqRoof0cmHNKU=";
  };

  # crash bundles a patched gdb whose version is tied to the crash release.
  # The gdb-16.2.patch below, the Makefile's GDB_16.2_* variables, and the
  # upstream README all expect exactly gdb 16.2, so pin it explicitly.
  gdbSrc = fetchurl {
    url = "https://ftp.gnu.org/gnu/gdb/gdb-16.2.tar.gz";
    hash = "sha256-vcHaSgMygKx1Ln00sEGO+qRb7QkyNcuI5i6pYXUqN/g=";
  };

  postUnpack = ''
    cp ${finalAttrs.gdbSrc} source/gdb-16.2.tar.gz
  '';

  nativeBuildInputs = [
    bison
    flex
    texinfo
  ];

  buildInputs = [
    ncurses
    zlib
    lzo
    snappy
    zstd
    gmp
    mpfr
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "/usr/bin/install" "install" \
      --replace-fail 'INSTALLDIR=''${DESTDIR}/usr/bin' "INSTALLDIR=$out/bin"

    substituteInPlace gdb-16.2.patch \
      --replace-fail "/bin/cat" "cat"
  '';

  outputs = [
    "out"
    "dev"
    "man"
  ];

  makeFlags = [
    "RPMPKG=${finalAttrs.version}"
  ];

  buildFlags = [
    "lzo"
    "snappy"
    "zstd"
  ];

  postInstall = ''
    install -Dm644 crash.8 $man/share/man/man8/crash.8
    install -Dm644 defs.h $dev/include/crash/defs.h
  '';

  meta = {
    description = "Linux kernel crash analysis utility";
    longDescription = ''
      A self-contained tool that can be used to investigate either live
      systems or kernel core dumps created from dump creation facilities
      such as kdump, kvmdump, xendump, netdump, diskdump and others.
    '';
    homepage = "https://crash-utility.github.io/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "crash";
    maintainers = with lib.maintainers; [ Martins3 ];
    platforms = lib.platforms.linux;
  };
})
