{
  lib,
  stdenvNoCC,
  installAgentSkills,
}:

stdenvNoCC.mkDerivation {
  # explicit pname is rquired for the hook to work but
  # name is manually set to keep drvPath consistent across
  # tests for installAgentSkills
  pname = "test";
  name = "install-agent-skills--dont-install-skills";

  strictDeps = true;
  __structuredAttrs = true;

  # src is required to be passed to mkDerivation
  src = null;
  dontUnpack = true;

  nativeBuildInputs = [ installAgentSkills ];

  dontInstallAgentSkills = true;

  # build phase happens before the hook is called to install the skills
  buildPhase = ''
    runHook preBuild

    mkdir -p test-skill/
    touch test-skill/SKILL.md

    runHook postBuild
  '';

  # if the skill file is created then the test should fail
  installCheckPhase = ''
    runHook preInstallCheck

    if test -f $out/share/skills/$pname/test-skill/SKILL.md; then
      exit 1
    fi

    touch $out

    runHook postInstallCheck
  '';
  doInstallCheck = true;

  meta.platforms = lib.platforms.all;
}
