{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  python3,
}:

buildNpmPackage rec {
  pname = "nest-cli";
  version = "11.0.10";

  src = fetchFromGitHub {
    owner = "nestjs";
    repo = "nest-cli";
    tag = version;
    hash = "sha256-mNnEbZv6LG5YDYZj7kAiPcg2Se9wJidON+9Tp/TIpd4=";
  };

  npmDepsHash = "sha256-dEg0WmNNNLMQj+9bHkwf0uz9Vyx+QFSHrQv7fk1DxjQ=";
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
