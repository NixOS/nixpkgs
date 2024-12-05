{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "create-react-app";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "create-react-app";
    rev = "v${version}";
    hash = "sha256-nUvJRxBZ98ogSkbw8ciFYtZRQNFD6pLThoEjeDMcGm0=";
  };

  npmDepsHash = "sha256-diGu53lJi+Fs7pTAQGCXoDtP7YyKZLIN/2Wo+e1Mzc4=";

  env.PUPPETEER_SKIP_DOWNLOAD = true;

  npmWorkspace = "packages/create-react-app";

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/facebook/create-react-app/blob/${src.rev}/CHANGELOG.md";
    description = "Create React apps with no build configuration";
    homepage = "https://github.com/facebook/create-react-app";
    license = lib.licenses.mit;
    mainProgram = "create-react-app";
    maintainers = [ ];
  };
}
