{
  lib,
  installAgentSkills,
  runCommandLocal,
}:

runCommandLocal "install-agent-skills--symlink-install-skill"
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

    ln -s skill-xyz skill-abc

    installSkill ./skill-xyz
    installSkill ./skill-abc

    cmp skill-xyz/SKILL.md $out/share/skills/$pname/skill-xyz/SKILL.md
    cmp $out/share/skills/$pname/skill-xyz/SKILL.md $out/share/skills/$pname/skill-abc/SKILL.md
    if [ -L $out/share/skills/$pname/skill-abc ]; then exit 1; fi
  ''
