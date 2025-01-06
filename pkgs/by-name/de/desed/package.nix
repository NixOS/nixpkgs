{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "desed";
  version = "1.2.1-unstable-2024-09-06";

  src = fetchFromGitHub {
    owner = "SoptikHa2";
    repo = "desed";
    rev = "master";
    hash = "sha256-iCpEfefXXognk4YI1LLb3mwgaqMw4m3haq/gdS1JbQU=";
  };

  cargoHash = "sha256-z2qv394C0GhQC21HuLyvlNjrM65KFEZh1XLj+Y/B9ZM=";

  meta = {
    changelog = "https://github.com/SoptikHa2/desed/releases/tag/v1.2.1";
    description = "Debugger for Sed: demystify and debug your sed scripts, from comfort of your terminal. ";
    homepage = "https://github.com/SoptikHa2/desed";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ vinylen ];
    mainProgram = "desed";
  };
}
