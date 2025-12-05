{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  python3,
}:

buildNpmPackage rec {
  pname = "nest-cli";
  version = "11.0.14";

  src = fetchFromGitHub {
    owner = "nestjs";
    repo = "nest-cli";
    tag = version;
    hash = "sha256-FvZRqQ/wDjEBhug99MZa/ZKcQXCF3I8fXom8hi2AQm4=";
  };

  npmDepsHash = "sha256-KnvcJqTSiW9pCt1MhwsTJmmmvwgtVK5hoLAs/B709MI=";
  npmFlags = [ "--legacy-peer-deps" ];

  env = {
    npm_config_build_from_source = true;
  };

  nativeBuildInputs = [
    python3
  ];

  meta = {
    homepage = "https://nestjs.com";
    description = "CLI tool for Nest applications";
    license = lib.licenses.mit;
    changelog = "https://github.com/nestjs/nest-cli/releases/tag/${version}";
    mainProgram = "nest";
    maintainers = with lib.maintainers; [
      ehllie
      phanirithvij
    ];
  };
}
