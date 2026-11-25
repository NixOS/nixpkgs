{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installAgentSkills,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "exa-agent-skills";
  version = "2026.11.23-53c2b03";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "exa-labs";
    repo = "agent-skills";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OokwB0L4BoCo3tGX/7KBU7fSgVIsk61+JSSE8JSk7Xc=";
  };

  nativeBuildInputs = [ installAgentSkills ];

  meta = {
    description = "Skills for the Exa API";
    homepage = "https://github.com/exa-labs/agent-skills";
    downloadPage = "https://github.com/exa-labs/agent-skills";
    changelog = "https://github.com/exa-labs/agent-skills/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ethancedwards8 ];
  };
})
