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
  version = "5.0.4";

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "glitchtip-frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2XZCIIWQAM2Nk8/JTs5MzUJJOvJS+wrsa2m/XiC9FHM=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-iJFEeUaPP6ZnntoZ2X0TyR6f923zPuzzZNW/zkd8M7E=";
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
