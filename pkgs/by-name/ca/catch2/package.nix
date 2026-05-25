{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "catch2";
  version = "2.13.10";

  src = fetchFromGitHub {
    owner = "catchorg";
    repo = "Catch2";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-XnT2ziES94Y4uzWmaxSw7nWegJFQjAqFUG8PkwK5nLU=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-H.." ];

  meta = {
    description = "Multi-paradigm automated test framework for C++ and Objective-C (and, maybe, C)";
    homepage = "http://catch-lib.net";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [
      edwtjo
    ];
    platforms = with lib.platforms; unix ++ windows;
  };
})
