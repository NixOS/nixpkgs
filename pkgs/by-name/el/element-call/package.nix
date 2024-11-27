{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, yarnConfigHook
, yarnBuildHook
, yarnInstallHook
, nodejs
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";
  offlineCacheHash = {
    x86_64-linux = "sha256-g4PWB1EstNB7gd/yZyrXf+U8Py8OLeea0gDlEXhInhU=";
    aarch64-linux = "sha256-g4PWB1EstNB7gd/yZyrXf+U8Py8OLeea0gDlEXhInhU=";
    x86_64-darwin = "sha256-g4PWB1EstNB7gd/yZyrXf+U8Py8OLeea0gDlEXhInhU=";
    aarch64-darwin = "sha256-g4PWB1EstNB7gd/yZyrXf+U8Py8OLeea0gDlEXhInhU=";
  }.${system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "element-call";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "element-call";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PyxqUhnlWfcACsoFYrppO7g5e74jI4/xxXBi6oWyWsg=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = offlineCacheHash;
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ];

  meta = with lib; {
    homepage = "https://github.com/element-hq/element-call";
    description = "Group calls powered by Matrix";
    license = licenses.asl20;
    maintainers = with maintainers; [ kilimnik ];
    mainProgram = "element-call";
  };
})
