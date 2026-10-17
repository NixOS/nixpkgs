{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  installAgentSkills,
  installShellFiles,
  makeWrapper,
  nix-update-script,
  nodejs_24,
  procps,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "rea";
  version = "6.5.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "morluto";
    repo = "rea";
    tag = "rea-agents-${finalAttrs.version}";
    hash = "sha256-fPe+tqkSRR5K+zSVWb6kjI6/HbQSJ8DHjLJwSWu8NzI=";
  };

  npmDepsHash = "sha256-EQKhS1S7Hsfjbo5GikMeAFc2HFtALsDcw6XnJATUryw=";

  # frida (optional dependency) installs a platform binary via
  # prebuild-install, which cannot work in the sandbox. None of the other
  # dependencies have install scripts.
  npmFlags = [ "--ignore-scripts" ];

  npmBuildScript = "compile";
  postBuild = "node scripts/generate-skill-metadata.mjs";

  # engines: ^22.19.0 || ^24.11.0 || >=26.0.0
  nodejs = nodejs_24;

  nativeBuildInputs = [
    installAgentSkills
    installShellFiles
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux makeWrapper;

  # The repo ships dev-facing skills under .agents/skills; only the bundled
  # user-facing one belongs in $out/share/skills.
  dontInstallAgentSkills = true;

  postInstall = ''
    # Without its platform binary the frida JS binding fails at load time
    # with a misleading error; remove it so that frida reports as missing.
    rm -rf "$out/lib/node_modules/rea-agents/node_modules/frida"

    installSkill skills/reverse-engineer-anything rea
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    "$out/bin/rea" completions bash > rea.bash
    "$out/bin/rea" completions fish > rea.fish
    "$out/bin/rea" completions nushell > rea.nu
    "$out/bin/rea" completions zsh > rea.zsh
    installShellCompletion rea.{bash,fish,nu,zsh}
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # Upstream requires a procps-compatible ps on PATH for Linux
    # owned-process analysis; macOS uses /bin/ps and its own helpers.
    wrapProgram "$out/bin/rea" --prefix PATH : ${lib.makeBinPath [ procps ]}
    wrapProgram "$out/bin/rea-agents" --prefix PATH : ${lib.makeBinPath [ procps ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Reverse engineer anything from your terminal or agent with one CLI and MCP server";
    homepage = "https://github.com/morluto/rea";
    changelog = "https://github.com/morluto/rea/releases/tag/rea-agents-${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "rea";
    maintainers = with lib.maintainers; [ luochen1990 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
