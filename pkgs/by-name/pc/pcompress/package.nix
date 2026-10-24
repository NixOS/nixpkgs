{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  automake,
  libtool,
  perl,
  pkg-config,
  which,
  yasm,
  openssl,
  zlib,
  bzip2,
  llvmPackages,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pcompress";
  version = "4.2.0";

  # The release tarball bundles the pinned lz4, zstd, libbsc and libarchive
  # sources (git submodules); pcompress patches libarchive and builds them
  # in-tree. GitHub's auto-generated archives omit the submodules.
  src = fetchurl {
    url = "https://github.com/gburd/pcompress/releases/download/v${finalAttrs.version}/pcompress-${finalAttrs.version}.tar.gz";
    hash = "sha256-mC6ndIhkSlRRmYfcCrkOvKvjf6AXSAsW4ptIptC3RHc=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    perl
    pkg-config
    which
  ]
  ++ lib.optional stdenv.hostPlatform.isx86_64 yasm;

  buildInputs = [
    openssl
    zlib
    bzip2
  ]
  ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  strictDeps = true;
  __structuredAttrs = true;

  # ./config is a hand-written script, not autoconf. --portable: no host
  # CPU probing (SIMD paths are still chosen at run time).
  configureScript = "./config";
  dontDisableStatic = true;
  configureFlags = [
    "--portable"
    "--disable-wavpack"
  ];
  checkTarget = "check";
  enableParallelBuilding = true;

  doCheck = true;
  doInstallCheck = true;

  preConfigure = ''
    patchShebangs config test
  '';

  # LLVM libomp's topology probe asserts in the build sandbox on aarch64;
  # pcompress does not rely on thread affinity.
  preCheck = ''
    export KMP_AFFINITY=disabled
  '';

  postInstall = ''
    install -Dm644 COPYING COPYING.LESSER -t $out/share/doc/pcompress
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-V";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Parallel compressor and archiver with deduplication, delta compression and encryption";
    longDescription = ''
      Pcompress splits its input into chunks and compresses them in parallel
      with one of many algorithms (zstd, LZMA, PPMd, libbsc, LZ4, zlib, bzip2,
      or adaptive per-chunk selection). It can deduplicate within a chunk or
      across the whole input, delta-encode similar blocks, apply content
      filters (JPEG, PNM, x86 code, text) in archive mode, and encrypt and
      authenticate every chunk with AES or XSalsa20.
    '';
    homepage = "https://codeberg.org/gregburd/pcompress";
    changelog = "https://codeberg.org/gregburd/pcompress/src/tag/v${finalAttrs.version}/Changelog";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ gburd ];
    mainProgram = "pcompress";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    badPlatforms = [ lib.systems.inspect.patterns.is32bit ];
  };
})
