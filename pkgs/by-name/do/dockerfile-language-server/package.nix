{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "dockerfile-language-server";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "rcjsuen";
    repo = "dockerfile-language-server";
    tag = "v${version}";
    hash = "sha256-oPU9XVxD9GbXMWkeGKncriFi1oP3YlkWnjxzltaz/iU=";
  };

  preBuild = ''
    npm run prepublishOnly
  '';

  npmDepsHash = "sha256-p5BBKoq+ANR8z4YWsjmKaNqkyQGETwG5OmdapasLk+c=";

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
