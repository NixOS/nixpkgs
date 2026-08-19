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
  version = "6.2.6";

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "glitchtip-frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i4ZlIyWIlRIW7bOu8Ae+3Yu84VBHacW0rnkLvd7D0Lk=";
  };

  nodejs = nodejs_22;

  npmDepsFetcherVersion = 2;
  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    fetcherVersion = 2;
    hash = "sha256-6+YQoMEg9jTOzzOdDQoJCbuvQtaVLIm54olzxKiR+5g=";
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
