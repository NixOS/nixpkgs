{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
  nix-your-shell,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-your-shell";
  version = "1.4.8";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = "nix-your-shell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2KiqDqKKT28yjCEtU0vFd+dFktGd6Xp+yxSSI/R7fjc=";
  };

  cargoHash = "sha256-BBKnA/QX37qEtWw69+nS1NjurI2GXASUrfY1E0iL/0Q=";

  passthru = {
    generate-config =
      shell:
      runCommand "nix-your-shell-config" { } ''
        ${lib.getExe nix-your-shell} ${lib.escapeShellArg shell} >> "$out"
      '';
    updateScript = nix-update-script { };
  };

  meta = {
    mainProgram = "nix-your-shell";
    description = "`nix` and `nix-shell` wrapper for shells other than `bash`";
    homepage = "https://github.com/MercuryTechnologies/nix-your-shell";
    changelog = "https://github.com/MercuryTechnologies/nix-your-shell/releases/tag/v${finalAttrs.version}";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ _9999years ];
  };
})
