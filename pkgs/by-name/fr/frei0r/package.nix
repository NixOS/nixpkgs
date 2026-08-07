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
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "dyne";
    repo = "frei0r";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eBaaEE+4mKYr5VCXUnoS/4aE6EV8DnXFJLFYsrk3gs0=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    cairo
    gavl
    opencv
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvcc
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
