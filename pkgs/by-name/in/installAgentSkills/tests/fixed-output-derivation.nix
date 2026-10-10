{
  lib,
  stdenvNoCC,
  testers,
  installAgentSkills,
}:

# Fixed-output derivations can inherit this hook through nativeBuildInputs.
# Installing skills there would alter the output and break its hash.
# The salted name forces a rebuild whenever the hook changes.
testers.invalidateFetcherByDrvHash stdenvNoCC.mkDerivation {
  # no pname, like buildGoModule's goModules
  name = "install-agent-skills--fixed-output-derivation";

  strictDeps = true;
  __structuredAttrs = true;

  # src is required to be passed to mkDerivation
  src = null;
  dontUnpack = true;

  nativeBuildInputs = [ installAgentSkills ];

  # build phase happens before the hook is called to install the skills
  buildPhase = ''
    runHook preBuild

    mkdir -p test-skill/
    touch test-skill/SKILL.md

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    echo ok > $out

    runHook postInstall
  '';

  outputHashMode = "flat";
  outputHashAlgo = "sha256";
  outputHash = "sha256-3FG4yWwtdF3zvVWQ2ZAjCkgv0kcSNZlUjgYy/b+X/CI=";

  meta.platforms = lib.platforms.all;
}
