{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "doctest";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "doctest";
    repo = "doctest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7t/eknv7VtHoBgcuJmI07x//HIyqzE9HUuH5u2y7X8A=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isStatic [
    # One of the examples tests shared library support
    # and fails linking.
    "-DDOCTEST_WITH_TESTS=OFF"
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/doctest/doctest";
    description = "Fastest feature-rich C++11/14/17/20 single-header testing framework";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
