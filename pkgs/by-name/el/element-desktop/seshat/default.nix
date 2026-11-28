{
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  nodejs,
  yarn,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  sqlcipher,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "seshat-node";
  version = "6.0.1-unstable-2026-11-19";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "seshat";
    rev = "d1e66b56712597e38246d9122630a9fa6b97e32b";
    hash = "sha256-axYa86vbpqc3gXNLJa1rUrB4lJZhN2HQI3hMC5uSNWU=";
  };

  cargoHash = "sha256-tXDzI8Z1GKKL7E62XLI5mJeBg3Hilar92xnWrsjJBN8=";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/seshat-node/yarn.lock";
    hash = "sha256-HigLBXDy29ki+HAHJoM6DKH7VSE6EanV4DbegPZnd1A=";
  };

  nativeBuildInputs = [
    nodejs
    yarn
    yarnConfigHook
    yarnBuildHook
  ];

  preConfigure = ''
    cp seshat-node/yarn.lock yarn.lock
    cp seshat-node/package.json package.json
  '';

  buildInputs = [ sqlcipher ];

  buildPhase = ''
    PATH=$PATH:$PWD/node_modules/.bin
    yarn --offline --cwd=seshat-node build
  '';

  checkFlags = [
    # thread panicks with IOError DirectoryNotEmpty
    "--skip=delete"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    mv "seshat-node/index."{node,js} "$out"

    runHook postInstall
  '';

  disallowedReferences = [ stdenv.cc.cc ];
})
