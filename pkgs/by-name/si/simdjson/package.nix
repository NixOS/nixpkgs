{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simdjson";
  version = "4.6.11";

  src = fetchFromGitHub {
    owner = "simdjson";
    repo = "simdjson";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JjcvJldWQTTFq9PU1F0IafL7GVoMfVUDz6hVb5Po/A4=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];

  strictDeps = true;
  __structuredAttrs = true;

  cmakeFlags = [
    (lib.cmakeBool "SIMDJSON_DEVELOPER_MODE" false)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ]
  ++ lib.optionals (with stdenv.hostPlatform; isPower && isBigEndian) [
    # Assume required CPU features are available, since otherwise we
    # just get a failed build.
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-mpower8-vector")
  ];

  passthru = {
    updateScript = nix-update-script { };

    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://simdjson.org/";
    changelog = "https://github.com/simdjson/simdjson/releases/tag/${finalAttrs.src.tag}";
    description = "Parsing gigabytes of JSON per second";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ chessai ];
    pkgConfigModules = [ "simdjson" ];
  };
})
