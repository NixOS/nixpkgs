{
  lib,
  fetchFromGitLab,
  buildNpmPackage,
  fetchNpmDeps,
  jq,
  moreutils,
}:

buildNpmPackage (finalAttrs: {
  pname = "glitchtip-frontend";
  version = "5.1.0";

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "glitchtip-frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8l/V2u/j3nF6GqFlQwK33pQuRAPXmqitmrNq6Z8p7ZQ=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-Lvhf80O/UTFABIGHjSVz4olBkEMUoE7XX66PD6P/FiA=";
  };

  postPatch = ''
    jq '.devDependencies |= del(.cypress, ."cypress-localstorage-commands")' package.json | sponge package.json
  '';

  nativeBuildInputs = [
    moreutils
    jq
  ];

  buildPhase = ''
    runHook preBuild

    npm run build-prod

    runHook postBuild
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
      defelo
      felbinger
    ];
  };
})
