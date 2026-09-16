{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "claude-powerline";
  version = "1.30.3";

  src = fetchFromGitHub {
    owner = "Owloops";
    repo = "claude-powerline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MBCISwf1xfiBD172IIl51t3Pun5gkjRnwhpWF0Y9Riw=";
  };

  npmDepsHash = "sha256-D3Z5tb4phZUMPQaXvfYiIWuwaX5YGI8ubgyV7sSJqQk=";

  __structuredAttrs = true;

  doCheck = true;
  # jest forks its worker children with FORCE_COLOR=1, which fails the terminal
  # detection cases in test/colors.test.ts. --runInBand keeps them in-process.
  checkPhase = ''
    runHook preCheck

    npm test -- --runInBand

    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Beautiful vim-style powerline for Claude Code";
    homepage = "https://github.com/Owloops/claude-powerline";
    changelog = "https://github.com/Owloops/claude-powerline/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cohei ];
    mainProgram = "claude-powerline";
  };
})
