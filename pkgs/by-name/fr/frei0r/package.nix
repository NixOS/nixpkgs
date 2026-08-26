{
  cairo,
  cmake,
  config,
  fetchFromGitHub,
  gavl,
  lib,
  opencv,
  pkg-config,
  stdenv,
  cudaPackages,
  cudaSupport ? config.cudaSupport,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frei0r-plugins";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "dyne";
    repo = "frei0r";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DcimKzQHlS9qXxaRHQ5wIGFtnEijHQjtm6pTBEW0OPk=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];
  buildInputs = [
    cairo
    opencv
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    gavl
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITHOUT_GAVL" (!stdenv.hostPlatform.isLinux))
  ]
  ++ lib.optionals cudaSupport [
    (lib.cmakeFeature "CUDAToolkit_ROOT" "${lib.getBin cudaPackages.cuda_nvcc}")
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for f in $out/lib/frei0r-1/*.so* ; do
      ln -s $f "''${f%.*}.dylib"
    done
  '';

  meta = {
    description = "Minimalist, cross-platform, shared video plugins";
    homepage = "https://frei0r.dyne.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      nick-linux
    ];
    platforms = lib.platforms.unix;
  };
})
