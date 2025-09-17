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

stdenv.mkDerivation rec {
  pname = "frei0r-plugins";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "dyne";
    repo = "frei0r";
    rev = "v${version}";
    hash = "sha256-95d1aXfCq4mPccY8VKmO7jkX57li6OVSwtfIf9459n4=";
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

  meta = with lib; {
    homepage = "https://frei0r.dyne.org";
    description = "Minimalist, cross-platform, shared video plugins";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
