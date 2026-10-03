{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "openskills";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "numman-ali";
    repo = "openskills";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rOrLi43J+w6XBRZYYwlDPl8RqU7Zhr45B9UyP6Xarj0=";
  };

  npmDepsHash = "sha256-3ESEmIuCw/zdTW92Y7tJlRs5sKnu2+7O9HkeX9aKfS4=";

  doCheck = true;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Universal skills loader for AI coding agents";
    longDescription = ''
      OpenSkills brings Anthropic's skills system to every AI coding
      agent — Claude Code, Cursor, Windsurf, Aider, Codex, and anything
      that can read AGENTS.md. Think of it as the universal installer for SKILL.md.
    '';
    homepage = "https://github.com/numman-ali/openskills";
    changelog = "https://github.com/numman-ali/openskills/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/numman-ali/openskills/releases";
    license = lib.licenses.asl20;
    mainProgram = "openskills";
    maintainers = with lib.maintainers; [ MH0386 ];
  };
})
