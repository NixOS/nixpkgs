# `installAgentSkills` {#installAgentSkills}

This hook automatically installs LLM agent skills into the proper location in `$out/share/skills/($pname|$base)/$skill/`. Any consumers (codex, pi-coding-agent, etc.) should be configured to look for skills in this location.

The automatic behavior of the hook can be disabled by setting the `dontInstallAgentSkills` variable to true.

Additionally, it exposes the `installSkill` function that can be used from `postInstall`

## `installSkill` {#installAgentSkills-installSkill}

The `installSkill` function takes one or two arguments: a directory to copy to the install location, and an optional base directory.

NB: passing a SKILL.md file directly as the first argument will fail as skills often contain other examples and tooling within the same directory.

### Example Usage {#installAgentSkills-installSkill-exampleusage}

```nix
{
  nativeBuildInputs = [ installAgentSkills ];

  postInstall = ''
    installSkill skills/skill-xyz
  '';
  # installs to $out/share/skills/$pname/skill-xyz

  # OR

  postInstall = ''
    installSkill skills/skill-xyz random-base
  '';
  # installs to $out/share/skills/random-base/skill-xyz
}
```

Where `skills/skill-xyz` may look like:

```
skills/skill-xyz:
  - SKILL.md
  - scripts/
  - referneces/
  - assets/
  - ...
```

