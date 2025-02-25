{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  jq,
}:
buildNpmPackage {
  name = "json2ts";
  version = "15.0.2";
  src = fetchFromGitHub {
    owner = "bcherny";
    repo = "json-schema-to-typescript";
    rev = "118d6a8e7a5a9397d1d390ce297f127ae674a623";
    hash = "sha256-ldAFfw3E0A0lIJyDSsshgPRPR7OmV/FncPsDhC3waT8=";
  };

  nativeBuildInputs = [ jq ];
  npmDepsHash = "sha256-kLKau4SBxI9bMAd7X8/FQfCza2sYl/+0bg2LQcOQIJo=";

  # forceConsistentCasingInFileNames: false is needed for typescript on darwin
  # https://www.typescriptlang.org/tsconfig/#forceConsistentCasingInFileNames
  postConfigure = ''
    jq '.compilerOptions.forceConsistentCasingInFileNames = false' tsconfig.json > temp.json
    mv temp.json tsconfig.json
  '';

  meta = with lib; {
    mainProgram = "json2ts";
    description = "Compile JSON Schema to TypeScript type declarations";
    homepage = "https://github.com/bcherny/json-schema-to-typescript";
    changelog = "https://github.com/bcherny/json-schema-to-typescript/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hsjobeki ];
    platforms = platforms.all;
  };
}
