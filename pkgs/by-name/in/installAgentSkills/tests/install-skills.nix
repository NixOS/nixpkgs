{
  lib,
  stdenvNoCC,
  installAgentSkills,
}:

stdenvNoCC.mkDerivation {
  # explicit pname is rquired for the hook to work but
  # name is manually set to keep drvPath consistent across
  # tests for installAgentSkills
  pname = "test-installSkills";
  name = "install-agent-skills--install-skills";

  strictDeps = true;
  __structuredAttrs = true;

  # src is required to be passed to mkDerivation
  src = null;
  dontUnpack = true;

  nativeBuildInputs = [ installAgentSkills ];

  # build phase happens before the hook is called to install the skills
  buildPhase = ''
    runHook preBuild

    for skill in xyz abc nix; do
      mkdir -p "skill-$skill"
      echo "This is skill $skill" > "skill-$skill/SKILL.md"
    done

    runHook postBuild
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    for skill in xyz abc nix; do
      cmp "skill-$skill/SKILL.md" "$out/share/skills/$pname/skill-$skill/SKILL.md"
    done

    runHook postInstallCheck
  '';
  doInstallCheck = true;

  meta.platforms = lib.platforms.all;
}
