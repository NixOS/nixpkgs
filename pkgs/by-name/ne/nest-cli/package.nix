{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  python3,
}:

buildNpmPackage rec {
  pname = "nest-cli";
<<<<<<< HEAD
  version = "11.0.14";
=======
  version = "11.0.12";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "nestjs";
    repo = "nest-cli";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-FvZRqQ/wDjEBhug99MZa/ZKcQXCF3I8fXom8hi2AQm4=";
  };

  npmDepsHash = "sha256-KnvcJqTSiW9pCt1MhwsTJmmmvwgtVK5hoLAs/B709MI=";
=======
    hash = "sha256-bi9kHxAio5ya2slmrm4U/uj9+UZondI/7aEde6rHGgM=";
  };

  npmDepsHash = "sha256-rsgLe2wZPPHKR8ORI5ICTc5/A03x+ICetvKnltTje4k=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
