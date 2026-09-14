{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installAgentSkills,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "exa-agent-skills";
  version = "2026.09.11-e7de871";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "exa-labs";
    repo = "agent-skills";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v8iHcDvKe7Ls1P7V0izJneyo3vYyW4dSzgUdmWeAP7o=";
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
