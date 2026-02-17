{
  lib,
  config,
  stdenv,
  fetchFromGitHub,
  cairo,
  cmake,
  opencv,
  pkg-config,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frei0r-plugins";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "dyne";
    repo = "frei0r";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3gUWvO5izOrJt+XwcNBNiLfu+iMqo4nuPbx++TYzao0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    cairo
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
    homepage = "https://frei0r.dyne.org";
    description = "Minimalist, cross-platform, shared video plugins";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
