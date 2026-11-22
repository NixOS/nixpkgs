{
  fetchFromGitHub,
  installAgentSkills,
  lib,
  nix-update-script,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mattpocock-skills";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "mattpocock";
    repo = "skills";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ej0ATi0BWaAx+83dBwgCQxr9J2L2qEwKhUIeIRJ03Go=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ installAgentSkills ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/mattpocock/skills/releases/tag/${finalAttrs.src.tag}";
    description = "Agent skills for software engineering and productivity";
    homepage = "https://www.aihero.dev/skills";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ connor-grady ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
