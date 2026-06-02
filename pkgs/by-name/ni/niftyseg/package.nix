{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "niftyseg";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "KCL-BMEIS";
    repo = "NiftySeg";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-FDthq1ild9XOw3E3O7Lpfn6hBF1Frhv1NxfEA8500n8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    eigen
    zlib
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)" \
      --replace-fail "cmake_minimum_required(VERSION 3.0.2)" "cmake_minimum_required(VERSION 3.10)" \
      --replace-fail "cmake_policy(VERSION 2.8)" "cmake_policy(VERSION 3.10)"
  '';

  meta = {
    homepage = "http://cmictig.cs.ucl.ac.uk/research/software/software-nifty/niftyseg";
    description = "Software for medical image segmentation, bias field correction, and cortical thickness calculation";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
    # last successful hydra build on darwin was in 2023
    broken = stdenv.hostPlatform.isDarwin;
  };

})
