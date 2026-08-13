{
  lib,
  stdenv,
  fetchFromGitHub,
  writeScript,

  # nativeBuildInputs
  cmake,
  xxd,

  # buildInputs
  nlohmann_json,
  nlohmann_json_schema_validator,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mnxdom";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "rpatters1";
    repo = "mnxdom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zM8NRdVKY4RI9fNrVU/BpWOkhmmT9HLrOi21YKPGd0k=";
  };

  nativeBuildInputs = [
    cmake
    xxd
  ];

  propagatedBuildInputs = [
    # nlohmann_json is a header only library, and we propagate it because it is
    # being `#include`d in `${placeholder "dev"}/include`.
    nlohmann_json
  ];
  buildInputs = [
    nlohmann_json_schema_validator
  ];

  checkInputs = [
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_NLOHMANN_JSON" true)
    (lib.cmakeBool "USE_SYSTEM_JSON_SCHEMA_VALIDATOR" true)
    (lib.cmakeBool "USE_SYSTEM_GOOGLETEST" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeFeature "MNX_W3C_SOURCE" (toString (finalAttrs.finalPackage.mnx_w3c)))
  ];
  doCheck = true;

  outputs = [
    "out"
    "dev"
  ];

  passthru = {
    # It is not a real package that needs building - it is just a bunch of
    # files. It is comfortable though to have a pname & version for it, to be
    # able to update it with automatic nix-update or alike. The meta.license is
    # also slightly interesting.
    mnx_w3c = stdenv.mkDerivation {
      pname = "mnx";
      version = "0-unstable-2026-02-17";

      src = fetchFromGitHub {
        owner = "w3c";
        repo = "mnx";
        rev = "d513cf7a28a84c803ed36e448b416cb49c3a22f9";
        hash = "sha256-YFiy+2kV/he770BolhDllKW2a6izc+Zu1PdiZKW9mlY=";
      };

      builder = writeScript "builder.sh" ''
        cp -r $src $out
      '';

      meta = {
        description = "Music Notation CG next-generation music markup proposal";
        homepage = "https://github.com/w3c/mnx";
        license = lib.licenses.w3c;
        platforms = lib.platforms.all;
      };
    };
  };

  meta = {
    description = "MNX Document Object Model for C++17";
    homepage = "https://github.com/rpatters1/mnxdom";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "mnxdom";
    platforms = lib.platforms.all;
  };
})
