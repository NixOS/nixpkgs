{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "element-call";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "element-call";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BugR5aXDxIQ9WOhaqXEoo0FdZHnYSvoqDoRJLDd4PUk=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-7dUSt1k/5N6BaYrT272J6xxDGgloAsDw1dCFh327Itc=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r dist/* $out

    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/element-hq/element-call/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/element-hq/element-call";
    description = "Group calls powered by Matrix";
    license = licenses.asl20;
    maintainers = with maintainers; [ kilimnik ];
  };
})
