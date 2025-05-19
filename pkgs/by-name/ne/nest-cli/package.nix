{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  python3,
}:

buildNpmPackage rec {
  pname = "nest-cli";
  version = "11.0.7";

  src = fetchFromGitHub {
    owner = "nestjs";
    repo = "nest-cli";
    tag = version;
    hash = "sha256-CCNbkSu/ymSKdFVDKZezekVFXl6Ipg9Dp9+Tyd4D+cY=";
  };

  npmDepsHash = "sha256-R9uSOeoQJw061ZEJMe8aDYUaUC1QvHQ9nOyoQa+z+fY=";
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
