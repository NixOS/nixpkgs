{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  nix-update-script,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hdrhistogram_c";
  version = "0.11.10";

  src = fetchFromGitHub {
    owner = "HdrHistogram";
    repo = "HdrHistogram_c";
    tag = finalAttrs.version;
    hash = "sha256-LMZj7vuxOA1bgU/J10IKnyNe3R0dk2AA1ydLTHun4vg=";
  };

  # Fix build on i686 by not trying to build AVX2 code
  # Submitted upstream: https://github.com/HdrHistogram/HdrHistogram_c/pull/143
  patches = [
    ./no-avx2-i386.patch
  ];

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];
  buildInputs = [ zlib ];

  strictDeps = true;

  cmakeFlags = lib.optionals stdenv.hostPlatform.isStatic [
    (lib.cmakeBool "HDR_HISTOGRAM_BUILD_SHARED" false)
    # Examples and tests depend on the shared library target; skip them in
    # static builds (tests still run for the regular pkgs.hdrhistogram_c build).
    (lib.cmakeBool "HDR_HISTOGRAM_BUILD_PROGRAMS" false)
  ];

  # The .pc file always references -lhdr_histogram, but in static builds only
  # libhdr_histogram_static.a is produced. Provide a symlink so pkg-config
  # consumers find the right archive.
  postInstall = lib.optionalString stdenv.hostPlatform.isStatic ''
    ln -s $out/lib/libhdr_histogram_static.a $out/lib/libhdr_histogram.a
  '';

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };

    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
  };

  __structuredAttrs = true;

  meta = {
    description = "C port or High Dynamic Range (HDR) Histogram";
    homepage = "https://github.com/HdrHistogram/HdrHistogram_c";
    changelog = "https://github.com/HdrHistogram/HdrHistogram_c/releases/tag/${finalAttrs.version}";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ jherland ];
    pkgConfigModules = [ "hdr_histogram" ];
  };
})
