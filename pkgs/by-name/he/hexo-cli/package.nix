{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "hexo-cli";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "hexojs";
    repo = "hexo-cli";
    rev = "v${version}";
    hash = "sha256-mtbg9Fa9LBqG/aNfm4yEo4ymuaxuqhymkO1q6mYA2Fs=";
  };

  npmDepsHash = "sha256-VCHG1YMPRwEBbwgscSv6V+fTNVRpsCxWeyO8co4Zy6k=";

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
