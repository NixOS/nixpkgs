{
  lib,
  fetchFromGitLab,
  buildNpmPackage,
  fetchNpmDeps,
  jq,
  moreutils,
  nodejs_22,
}:

buildNpmPackage (finalAttrs: {
  pname = "glitchtip-frontend";
  version = "6.0.9";

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "glitchtip-frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NbAsiyX1nJLqhqEmkSHc2IlVdgKDqximhAQSJPEM2QM=";
  };

  nodejs = nodejs_22;

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    npmDepsFetcherVersion = 3;
    hash = "sha256-CH8fGLppFp+uivhx3gpo8vNAYHtCv0EBTLKGUAhrvSw=";
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
