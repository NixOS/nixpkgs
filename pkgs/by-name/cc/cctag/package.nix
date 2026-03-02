{
  lib,
  clangStdenv,
  fetchFromGitHub,

  cmake,
  boost,
  eigen,
  opencv,
  onetbb,

  avx2Support ? clangStdenv.hostPlatform.avx2Support,
}:
let
  stdenv = clangStdenv;
in
stdenv.mkDerivation rec {
  pname = "cctag";
  version = "1.0.4";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "alicevision";
    repo = "CCTag";
    rev = "v${version}";
    hash = "sha256-M35KGTTmwGwXefsFWB2UKAKveUQyZBW7V8ejgOAJpXk=";
  };

  cmakeFlags = [
    # Feel free to create a PR to add CUDA support
    "-DCCTAG_WITH_CUDA=OFF"

    "-DCCTAG_ENABLE_SIMD_AVX2=${if avx2Support then "ON" else "OFF"}"

    "-DCCTAG_BUILD_TESTS=${if doCheck then "ON" else "OFF"}"
    "-DCCTAG_BUILD_APPS=OFF"
  ];

  patches = [
    ./cmake-install-include-dir.patch
    ./cmake-no-apple-rpath.patch
  ];

  # darwin boost doesn't have math_c99 libraries
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt --replace-warn ";math_c99" ""
    substituteInPlace src/CMakeLists.txt --replace-warn "Boost::math_c99" ""
  '';

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    onetbb
  ];

  buildInputs = [
    boost
    eigen
    opencv.cxxdev
  ];

  doCheck = true;

  meta = {
    description = "Detection of CCTag markers made up of concentric circles";
    homepage = "https://cctag.readthedocs.io";
    downloadPage = "https://github.com/alicevision/CCTag";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ tmarkus ];
  };
}
