{
  lib,
  fetchFromGitLab,
  buildNpmPackage,
  jq,
  moreutils,
}:

buildNpmPackage (finalAttrs: {
  pname = "glitchtip-frontend";
  version = "4.2.5";

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "glitchtip-frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yLpDjHnt8ZwpT+KlmEtXMYgrpnbYlVzJ/MZMELVO/j8=";
  };

  npmDepsHash = "sha256-sR/p/JRVuaemN1euZ/VrJ0j1q7fkS/Zi6R1m6lPvygs=";

  postPatch = ''
    ${lib.getExe jq} '. + {
      "devDependencies": .devDependencies | del(.cypress, ."cypress-localstorage-commands")
    }' package.json | ${lib.getExe' moreutils "sponge"} package.json
  '';

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
