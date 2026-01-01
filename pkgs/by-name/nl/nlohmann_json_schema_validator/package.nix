{
  stdenv,
  lib,
  fetchFromGitHub,
  nlohmann_json,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nlohmann_json_schema_validator";
<<<<<<< HEAD
  version = "2.4.0";
=======
  version = "2.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "pboettch";
    repo = "json-schema-validator";
    rev = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-VTRnlkcSPMCRQiu5H2P44nHG1JMV9gl04xYjppstsk4=";
=======
    hash = "sha256-Ybr5dNmjBBPTYPvgorJ6t2+zvAjxYQISWXJmgUVHBVE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildInputs = [ nlohmann_json ];
  nativeBuildInputs = [ cmake ];

  meta = {
    description = "JSON schema validator for JSON for Modern C++";
    homepage = "https://github.com/pboettch/json-schema-validator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ br337 ];
    platforms = lib.platforms.all;
  };
})
