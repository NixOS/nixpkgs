{
  lib,
  stdenv,
  fetchFromGitHub,
  catch2,
  cmake,
  unixODBC,
}:

stdenv.mkDerivation rec {
  pname = "nanodbc";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "nanodbc";
    repo = "nanodbc";
    rev = "v${version}";
    hash = "sha256-dVUOwA7LfLqcQq2nc6OAha0krmgTy5RUHupBVrNdo4g=";
  };

  postPatch = ''
    cp ${catch2}/include/catch2/catch.hpp test/catch/catch.hpp
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [ unixODBC ];

  cmakeFlags =
    if (stdenv.hostPlatform.isStatic) then
      [ "-DBUILD_STATIC_LIBS=ON" ]
    else
      [ "-DBUILD_SHARED_LIBS=ON" ];

  meta = {
    homepage = "https://github.com/nanodbc/nanodbc";
    changelog = "https://github.com/nanodbc/nanodbc/raw/v${version}/CHANGELOG.md";
    description = "Small C++ wrapper for the native C ODBC API";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bzizou ];
  };
}
