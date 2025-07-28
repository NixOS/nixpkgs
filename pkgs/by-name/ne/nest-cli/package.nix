{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  python3,
}:

buildNpmPackage rec {
  pname = "nest-cli";
  version = "11.0.8";

  src = fetchFromGitHub {
    owner = "nestjs";
    repo = "nest-cli";
    tag = version;
    hash = "sha256-vqu5eUtr8oO2HgQhXIHel92qHhHJSqyAJmI2+Oc5VoY=";
  };

  npmDepsHash = "sha256-QLJBqVHEvOhRRGU9x/5hCvRSi0xKYMDXeqMi6yWNHbU=";
  npmFlags = [ "--legacy-peer-deps" ];

  env = {
    npm_config_build_from_source = true;
  };

  nativeBuildInputs = [
    python3
  ];

  meta = with lib; {
    description = "CLI tool for Nest applications";
    homepage = "https://nestjs.com";
    license = licenses.mit;
    mainProgram = "nest";
    maintainers = [ maintainers.ehllie ];
  };
}
