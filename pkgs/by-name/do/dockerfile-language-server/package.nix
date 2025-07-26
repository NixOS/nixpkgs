{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "dockerfile-language-server";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "rcjsuen";
    repo = "dockerfile-language-server";
    tag = "v${version}";
    hash = "sha256-TYie0+SJLbQfrU7jhcmuOgUwMGfRGX6vSo8cHEAD0Eo=";
  };

  preBuild = ''
    npm run prepublishOnly
  '';

  npmDepsHash = "sha256-CaV8ogzw537tWPNyiDre5BfZ54o3CYqL4H5YWfWVHxM=";

  meta = {
    changelog = "https://github.com/rcjsuen/dockerfile-language-server/blob/${src.tag}/CHANGELOG.md";
    description = "Language server for Dockerfiles powered by Node.js, TypeScript, and VSCode technologies";
    homepage = "https://github.com/rcjsuen/dockerfile-language-server";
    license = lib.licenses.mit;
    mainProgram = "docker-langserver";
    maintainers = with lib.maintainers; [
      rvolosatovs
      net-mist
      dlugoschvincent
    ];
  };
}
