{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  catch2_3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfn";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "libfn";
    repo = "functional";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T4pKqLXo3kaCCEwXpVkXrCGRFdperBJsKW6meqIf+Xs=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  checkInputs = [ catch2_3 ];

  cmakeFlags = [
    (lib.cmakeBool "DISABLE_FETCH_CONTENT" true)
    (lib.cmakeBool "DISABLE_CCACHE_DETECTION" true)
    (lib.cmakeBool "LIBFN_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  meta = {
    description = "Functional programming in C++ using monadic composition";
    homepage = "https://libfn.org";
    changelog = "https://github.com/libfn/functional/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ bronek ];
    platforms = lib.platforms.unix;
  };
})
