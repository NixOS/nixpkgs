{
  lib,
  stdenv,
  cmake,
  ctestCheckHook,
  eigen,
  fetchFromGitHub,
  gtest,
  gz-cmake,
  gz-utils,
  python3Packages,
  ruby,
  swig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gz-math";
  version = "9.1.0";

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-math";
    tag = "gz-math${lib.versions.major finalAttrs.version}_${finalAttrs.version}";
    hash = "sha256-Kc9g5D52+NVygYLpMf+4GFPPn2sTEfXBOC14iw39NlA=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  buildInputs = [ gz-cmake ];

  nativeBuildInputs = [
    cmake
    swig
  ]
  ++ (with python3Packages; [
    python
    pybind11
  ]);

  propagatedBuildInputs = [
    gz-utils
    eigen
  ];

  doCheck = true;

  checkInputs = [ gtest ];

  nativeCheckInputs = [
    ctestCheckHook
    ruby
    python3Packages.python
  ];

  disabledTests = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # Non-deterministic random tests fail on aarch64-darwin
    "GaussMarkovProcess_TEST.rb"
    "Rand_TEST.rb"
  ];

  meta = {
    description = "Math classes and functions for robot applications";
    homepage = "https://gazebosim.org/home";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix ++ lib.platforms.windows ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ guelakais ];
  };
})
