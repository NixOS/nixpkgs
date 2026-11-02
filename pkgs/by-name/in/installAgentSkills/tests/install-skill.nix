{
  lib,
  installAgentSkills,
  runCommandLocal,
}:

runCommandLocal "install-agent-skills--install-skill"
  {
    strictDeps = true;
    __structuredAttrs = true;

    nativeBuildInputs = [ installAgentSkills ];
    meta.platforms = lib.platforms.all;
  }
  ''
    # required to functions/hook to work. this is a contrived example
    # so its fine to manually set here
    export pname=test-installSkill

    mkdir -p skill-xyz
    echo "This is a test agent skill!" > skill-xyz/SKILL.md

    installSkill ./skill-xyz

    cmp skill-xyz/SKILL.md $out/share/skills/$pname/skill-xyz/SKILL.md
  ''
