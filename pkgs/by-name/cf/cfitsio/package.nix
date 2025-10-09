{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  gitUpdater,
  cmake,
  bzip2,
  curl,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cfitsio";
  version = "4.6.2";

  src = fetchFromGitHub {
    owner = "HEASARC";
    repo = finalAttrs.pname;
    tag = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-WLsX23hNhaITjCvMEV7NUEvyDfQiObSJt1qFC12z7wY=";
  };

  outputs = [
    "bin"
    "dev"
    "out"
    "doc"
  ];

  patches = [
    ./cfitsio-pc-cmake.patch

    (fetchpatch {
      name = "cfitsio-fix-cmake-4.patch";
      url = "https://github.com/HEASARC/cfitsio/commit/101e0880fca41e2223df7eec56d9e84e90b9ed56.patch";
      hash = "sha256-rufuqOBfE7ItTYwsGdu9G4BXSz4vZd52XmJi09kqrCM=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    bzip2
    curl
    zlib
  ];

  cmakeFlags = [
    "-DUSE_PTHREADS=ON"
    "-DTESTS=ON"
    "-DUTILS=ON"
    "-DUSE_BZIP2=ON"
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isFreeBSD {
    # concerning. upstream defines XOPEN_SOURCE=700 which makes FreeBSD very insistent on
    # not showing us gethostbyname()
    NIX_CFLAGS_COMPILE = "-D__BSD_VISIBLE=1";
  };
  hardeningDisable = [ "format" ];

  doCheck = true;
  doInstallCheck = true;

  # On testing cfitsio: https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/README
  installCheckPhase = ''
    ./TestProg > testprog.lis
    diff -s testprog.lis ../testprog.out
    cmp testprog.fit ../testprog.std
  '';

  # Fixup installation
  # Remove installed test tools and benchmark
  postInstall = ''
    install -Dm644 -t "$out/share/doc/${finalAttrs.pname}" ../docs/*.pdf
    rm "$out/bin/cookbook"
    rmdir "$out/bin"
    rm "$bin/bin/smem" "$bin/bin/speed"
  '';

  passthru = {
    updateScript = gitUpdater { rev-prefix = "${finalAttrs.pname}-"; };
  };

  meta = {
    homepage = "https://heasarc.gsfc.nasa.gov/fitsio/";
    description = "Library for reading and writing FITS data files";
    longDescription = ''
      CFITSIO is a library of C and Fortran subroutines for reading and
      writing data files in FITS (Flexible Image Transport System) data
      format.  CFITSIO provides simple high-level routines for reading and
      writing FITS files that insulate the programmer from the internal
      complexities of the FITS format.  CFITSIO also provides many
      advanced features for manipulating and filtering the information in
      FITS files.
    '';
    changelog = "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/docs/changes.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      returntoreality
      xbreak
    ];
    platforms = lib.platforms.unix;
  };
})
