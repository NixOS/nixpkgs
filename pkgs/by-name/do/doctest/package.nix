{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "doctest";
  version = "2.4.12";

  src = fetchFromGitHub {
    owner = "doctest";
    repo = "doctest";
    tag = "v${version}";
    hash = "sha256-Fxs1EWydhqN9whx+Cn4fnZ4fhCEQvFgL5e9TUiXlnq8=";
  };

  patches = [
    # Fix the build with Clang.
    (fetchpatch {
      name = "doctest-disable-warnings.patch";
      url = "https://github.com/doctest/doctest/commit/c8d9ed2398d45aa5425d913bd930f580560df30d.patch";
      excludes = [ ".github/workflows/main.yml" ];
      hash = "sha256-kOBy0om6MPM2vLXZjNLXiezZqVgNr/viBI7mXrOZts8=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isStatic [
    # One of the examples tests shared library support
    # and fails linking.
    "-DDOCTEST_WITH_TESTS=OFF"
  ];

  doCheck = true;

  # Fix the build with LLVM 21 / GCC 15.
  #
  # See:
  #
  # * <https://github.com/doctest/doctest/issues/928>
  # * <https://github.com/doctest/doctest/pull/929>
  # * <https://github.com/doctest/doctest/issues/950>
  env.NIX_CFLAGS_COMPILE = lib.concatStringsSep " " [
    "-Wno-error=nrvo"
    "-Wno-error=missing-noreturn"
  ];

  meta = with lib; {
    homepage = "https://github.com/doctest/doctest";
    description = "Fastest feature-rich C++11/14/17/20 single-header testing framework";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = [ ];
  };
}
