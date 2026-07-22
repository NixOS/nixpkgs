{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "doctest";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "doctest";
    repo = "doctest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4jW6xPFCFxk1l47EkSUVojhycrtluPhOc5Adf/25R7M=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isStatic [
    # One of the examples tests shared library support
    # and fails linking.
    "-DDOCTEST_WITH_TESTS=OFF"
  ];

  doCheck = true;

  meta = {
    changelog = "https://github.com/doctest/doctest/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/doctest/doctest";
    description = "Fastest feature-rich C++11/14/17/20 single-header testing framework";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
