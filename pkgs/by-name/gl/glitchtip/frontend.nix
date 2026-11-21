{
  lib,
  fetchFromGitLab,
  buildNpmPackage,
  dart-sass,
  fetchNpmDeps,
  jq,
  moreutils,
  nodejs_24,
}:

buildNpmPackage (finalAttrs: {
  pname = "glitchtip-frontend";
  version = "7.0.0";

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "glitchtip-frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZJz/Le+EJ4ITm8xzCY+zC9LR1YIRtr+lWOCJUtFprZc=";
  };

  nodejs = nodejs_24;

  npmDepsFetcherVersion = 2;
  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    fetcherVersion = 2;
    hash = "sha256-UVUKWk8l/mGp6A4tZ2lTgQ4IhdJjRq2GUabqw59SxVc=";
  };

  postPatch = ''
    jq '.devDependencies |= del(.cypress, ."cypress-localstorage-commands")' package.json | sponge package.json
  '';

  nativeBuildInputs = [
    moreutils
    jq
  ];

  npmBuildScript = "build-prod";

  preBuild = ''
    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
      --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist/glitchtip-frontend/browser $out/

    runHook postInstall
  '';

  meta = {
    description = "Frontend for GlitchTip";
    homepage = "https://glitchtip.com";
    changelog = "https://gitlab.com/glitchtip/glitchtip-frontend/-/releases/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      felbinger
    ];
  };
})
