{
  stdenv,
  lib,
  fetchFromGitHub,
  nlohmann_json,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nlohmann_json_schema_validator";
  version = "2.4.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "pboettch";
    repo = "json-schema-validator";
    rev = finalAttrs.version;
    hash = "sha256-gA4KqlskJYNtrFRiVPaJEzo8Kk4rGqgN/MWACj+InP8=";
  };

  buildInputs = [ nlohmann_json ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  meta = {
    description = "JSON schema validator for JSON for Modern C++";
    homepage = "https://github.com/pboettch/json-schema-validator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ br337 ];
    platforms = lib.platforms.all;
  };
})
