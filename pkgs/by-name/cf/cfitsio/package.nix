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
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "HEASARC";
    repo = "cfitsio";
    tag = "cfitsio-${finalAttrs.version}";
    hash = "sha256-k05ylMYf+hsYur3BgNAweMeDc89rsBBtie+P7bd+7qg=";
  };

  patches = [
    # fix for CVE-2026-115504 can be removed with next release
    (fetchpatch {
      url = "https://github.com/heasarc/cfitsio/commit/113781d8aa442cf8d3c27295d9084674b8b039f2.patch";
      hash = "sha256-Je+z9a0ySQ93vfgGSr/PuqtxY3qPsmuOwVwsTQ3nfyY=";
    })
  ];

  outputs = [
    "bin"
    "dev"
    "out"
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
    rm "$out/bin/cookbook"
    rmdir "$out/bin"
    rm "$bin/bin/smem" "$bin/bin/speed"
  '';

  passthru = {
    updateScript = gitUpdater { rev-prefix = "${finalAttrs.pname}-"; };
  };

  meta = {
    homepage = "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/";
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
    license = lib.licenses.cfitsio;
    maintainers = with lib.maintainers; [
      returntoreality
      xbreak
    ];
    platforms = lib.platforms.unix;
  };
})
