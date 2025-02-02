{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "hexo-cli";
  version = "4.3.2";

  src = fetchFromGitHub {
    owner = "hexojs";
    repo = "hexo-cli";
    tag = "v${version}";
    hash = "sha256-qU2K1HOXEKs06SGEuyzEWag8JpD9EKWgEH15Z4pqEX4=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-ESbeNXkW9kQtlZnQq849Sr6zoLx1eKv8Fqvsep6Ibow=";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r bin/ dist/ node_modules/ package.json $out/

    runHook postInstall
  '';

  meta = {
    description = "Command line interface for Hexo";
    mainProgram = "hexo";
    homepage = "https://hexo.io/";
    license = lib.licenses.mit;
  };
}
