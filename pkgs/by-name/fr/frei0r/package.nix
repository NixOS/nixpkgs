{
  lib,
  config,
  stdenv,
  fetchFromGitHub,
  cairo,
  cmake,
  opencv,
  pkg-config,
  gavl,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frei0r-plugins";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "dyne";
    repo = "frei0r";
    rev = "v${finalAttrs.version}";
    hash = "sha256-D00sxSTnv4oqxhKYKayJPs5uWYW4HosEp2StuCVmGFY=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    cairo
    opencv
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) gavl
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvcc
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITHOUT_GAVL" stdenv.hostPlatform.isDarwin)
    (lib.cmakeFeature "FREI0R_VERSION" finalAttrs.version)
  ];

  doCheck = true;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for f in $out/lib/frei0r-1/*.so* ; do
      ln -s $f "''${f%.*}.dylib"
    done
  '';

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
    versionCheck = true;
  };

  meta = {
    homepage = "https://frei0r.dyne.org";
    description = "Minimalist, cross-platform, shared video plugins";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.christoph-heiss ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "frei0r" ];
  };
})
