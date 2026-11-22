{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "dockerfile-language-server";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "rcjsuen";
    repo = "dockerfile-language-server";
    tag = "v${version}";
    hash = "sha256-olgOUbVHHj9vD7upswqVJYBRIRb+kg6uXC2y5shnM+g=";
  };

  preBuild = ''
    npm run prepublishOnly
  '';

  npmDepsHash = "sha256-cJ11l2NF/sCzPw/eQNFon5oKRM+KPoy4lxLz0yivHTo=";

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
