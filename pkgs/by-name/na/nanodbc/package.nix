{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  catch2,
  cmake,
  unixodbc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nanodbc";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "nanodbc";
    repo = "nanodbc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dVUOwA7LfLqcQq2nc6OAha0krmgTy5RUHupBVrNdo4g=";
  };

  patches = [
    # Include cstdint with Clang instead of relying on transitive includes.
    (fetchpatch {
      url = "https://github.com/nanodbc/nanodbc/commit/64282577ec0005094c6df186bc424f1d2fab19a0.patch";
      hash = "sha256-KQE1u+yUAPgVqov2xDJf6nh+A8egMqqPcDdnw6WpPpY=";
    })
  ];

  postPatch = ''
    cp ${catch2}/include/catch2/catch.hpp test/catch/catch.hpp

    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.0.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [ unixodbc ];

  cmakeFlags =
    if (stdenv.hostPlatform.isStatic) then
      [ "-DBUILD_STATIC_LIBS=ON" ]
    else
      [ "-DBUILD_SHARED_LIBS=ON" ];

  meta = {
    homepage = "https://github.com/nanodbc/nanodbc";
    changelog = "https://github.com/nanodbc/nanodbc/raw/v${finalAttrs.version}/CHANGELOG.md";
    description = "Small C++ wrapper for the native C ODBC API";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bzizou ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})
