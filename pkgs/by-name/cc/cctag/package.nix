{
  lib,
  clangStdenv,
  fetchFromGitHub,

  cmake,
  boost186,
  eigen,
  opencv,
  onetbb,

  avx2Support ? clangStdenv.hostPlatform.avx2Support,
}:
let
  stdenv = clangStdenv;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cctag";
  version = "1.0.4";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "alicevision";
    repo = "CCTag";
    rev = "v${finalAttrs.version}";
    hash = "sha256-M35KGTTmwGwXefsFWB2UKAKveUQyZBW7V8ejgOAJpXk=";
  };

  cmakeFlags = [
    # Feel free to create a PR to add CUDA support
    (lib.cmakeBool "CCTAG_WITH_CUDA" false)

    (lib.cmakeBool "CCTAG_ENABLE_SIMD_AVX2" avx2Support)

    (lib.cmakeBool "CCTAG_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "CCTAG_BUILD_APPS" false)
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
    boost186
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
})
