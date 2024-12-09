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
    x86_64-linux = "sha256-bjWPoci9j3LZnOfDgmRVqQp1L2tXBwHQOryn+p5B1Mc=";
    aarch64-linux = "sha256-bjWPoci9j3LZnOfDgmRVqQp1L2tXBwHQOryn+p5B1Mc=";
    x86_64-darwin = "sha256-bjWPoci9j3LZnOfDgmRVqQp1L2tXBwHQOryn+p5B1Mc=";
    aarch64-darwin = "sha256-bjWPoci9j3LZnOfDgmRVqQp1L2tXBwHQOryn+p5B1Mc=";
  }.${system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "element-call";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "element-call";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HmkFr2DroN1uNNH2pnRwE7vsJsEPLYU6yhroiuR/E6Q=";
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
