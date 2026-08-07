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
  version = "6.2.0";

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "glitchtip-frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iKY1w9lmfuyvDblH/TlnUwAnda17qWGxmx1qtmQRENg=";
  };

  nodejs = nodejs_22;

  npmDepsFetcherVersion = 2;
  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    fetcherVersion = 2;
    hash = "sha256-xobZg0Hc+Yi9+q6kMwuKtBb4pjdYNS4T9VdFy5hARlw=";
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
