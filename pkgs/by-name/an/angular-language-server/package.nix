{
  lib,
  stdenv,
  fetchYarnDeps,
  fetchFromGitHub,
  nodejs,
  yarnConfigHook,
  yarnInstallHook,
}:

stdenv.mkDerivation rec {
  pname = "angular-language-server";
  version = "18.2.0";

  src = fetchFromGitHub {
    owner = "angular";
    repo = "vscode-ng-language-service";
    rev = "v${version}";
    hash = "sha256-9+WWKvy/Vu4k0BzJwPEme+9+eDPI1QP0+Ds1CbErCN8=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-N0N0XbNQRN7SHkilzo/xNlmn9U/T/WL5x8ttTqUmXl0=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnInstallHook
  ];

  buildInputs = [
    nodejs
  ];

  buildPhase = ''
    runHook preBuild

    tsc -b && yarn bazel build :npm

    runHook postBuild
  '';

  meta = {
    description = "Lsp for angular completions, AOT diagnostic, quick info and go to definitions";
    homepage = "https://github.com/angular/vscode-ng-language-service";
    changelog = "https://github.com/angular/vscode-ng-language-service/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "ngserver";
    maintainers = with lib.maintainers; [ bornedj ];
  };
}
