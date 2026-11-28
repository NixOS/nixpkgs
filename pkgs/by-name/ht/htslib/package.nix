{
  lib,
  stdenv,
  fetchurl,
  zlib,
  bzip2,
  xz,
  curl,
  libdeflate,
  perl,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "htslib";
  version = "1.25";

  src = fetchurl {
    url = "https://github.com/samtools/htslib/releases/download/${finalAttrs.version}/htslib-${finalAttrs.version}.tar.bz2";
    hash = "sha256-FYwnHk4phrst0RKDtkDtwQxWaVspPfd6EJzplIAwNzA=";
  };

  buildInputs = [
    zlib
    bzip2
    xz
    curl
    libdeflate
  ];

  nativeCheckInputs = [ perl ];

  configureFlags =
    if !stdenv.hostPlatform.isStatic then
      [ "--enable-libcurl" ] # optional but strongly recommended
    else
      [
        "--disable-libcurl"
        "--disable-plugins"
      ];

  # In the case of static builds, we need to replace the build and install phases
  buildPhase = lib.optionalString stdenv.hostPlatform.isStatic ''
    make AR=$AR lib-static
    make LDFLAGS=-static bgzip htsfile tabix
  '';

  installPhase = lib.optionalString stdenv.hostPlatform.isStatic ''
    install -d $out/bin
    install -d $out/lib
    install -d $out/include/htslib
    install -D libhts.a $out/lib
    install -m644 htslib/*h $out/include/htslib
    install -D bgzip htsfile tabix $out/bin
  '';

  preCheck = ''
    patchShebangs test/
  '';

  enableParallelBuilding = true;

  makeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # The ref-cache test starts loopback HTTP servers, which fail in the Darwin
    # sandbox. Skip only that test.
    "REF_CACHE_TEST_OPTS="
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C library for reading/writing high-throughput sequencing data";
    license = lib.licenses.mit;
    homepage = "https://www.htslib.org/";
    changelog = "https://github.com/samtools/htslib/releases/tag/${finalAttrs.version}";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.mimame ];
  };
})
