{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  zlib,
  bzip2,
  xz,
  curl,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "htslib";
  version = "1.22";

  src = fetchurl {
    url = "https://github.com/samtools/htslib/releases/download/${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-YlDB3yl9tHdRbmCsjfRe11plLR8lsPN/EvWxcmnq/ek=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/samtools/htslib/commit/31006e1c8edd02eb6321ed9be76b84fca5d20cb6.patch";
      hash = "sha256-sbnkVmXIbs/Cn/msUUrJpJZCI2DHX5kpGSka2cccZIQ=";
    })
  ];

  # perl is only used during the check phase.
  nativeBuildInputs = [ perl ];

  buildInputs = [
    zlib
    bzip2
    xz
    curl
  ];

  configureFlags =
    if !stdenv.hostPlatform.isStatic then
      [ "--enable-libcurl" ] # optional but strongly recommended
    else
      [
        "--disable-libcurl"
        "--disable-plugins"
      ];

  # In the case of static builds, we need to replace the build and install phases
  buildPhase = lib.optional stdenv.hostPlatform.isStatic ''
    make AR=$AR lib-static
    make LDFLAGS=-static bgzip htsfile tabix
  '';

  installPhase = lib.optional stdenv.hostPlatform.isStatic ''
    install -d $out/bin
    install -d $out/lib
    install -d $out/include/htslib
    install -D libhts.a $out/lib
    install  -m644 htslib/*h $out/include/htslib
    install -D bgzip htsfile tabix $out/bin
  '';

  preCheck = ''
    patchShebangs test/
  '';

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "C library for reading/writing high-throughput sequencing data";
    license = licenses.mit;
    homepage = "http://www.htslib.org/";
    platforms = platforms.unix;
    maintainers = [ maintainers.mimame ];
  };
}
