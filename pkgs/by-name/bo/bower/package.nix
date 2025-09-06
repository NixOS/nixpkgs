{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnInstallHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bower";
  version = "1.8.12";

  src = fetchFromGitHub {
    owner = "bower";
    repo = "bower";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZjDq4ExQebGB855bbRZCX62YkrrClhZJqU+ipv5v7BM=";
  };

  patches = [
    ./workspace-dependencies.patch
  ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-Y7tjFbyz3AKMvHAOB9U0KPdxmiO7tHPP+RdkSlSQJUc=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnInstallHook
  ];

  meta = {
    changelog = "https://github.com/bower/bower/releases/tag/v${finalAttrs.version}";
    description = "Package manager for the web";
    homepage = "https://bower.io";
    license = lib.licenses.mit;
    mainProgram = "bower";
  };
})
