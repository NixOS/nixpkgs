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
  version = "1.4.9";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = "nix-your-shell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mpgVlM3mFbjugEcWyhayEwSQvgj64jlAiy/RLgSTlyw=";
  };

  cargoHash = "sha256-ReK85FRyl+4Epr11XsIiPUR3wFl6/HJ5MmYDX9Impes=";

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
