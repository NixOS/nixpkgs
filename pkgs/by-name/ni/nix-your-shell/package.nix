{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
  nix-your-shell,
}:
rustPlatform.buildRustPackage rec {
  pname = "nix-your-shell";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = "nix-your-shell";
    tag = "v${version}";
    hash = "sha256-CE1yVD0uT5QnCfuTshAvM4r0BQ6XeaT22PdEhaYJJk8=";
  };

  cargoHash = "sha256-BGyO+MK5pRMNFauRvTWxluHoPjqqsIJP1yajWEJnIvI=";

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
    changelog = "https://github.com/MercuryTechnologies/nix-your-shell/releases/tag/v${version}";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ _9999years ];
  };
}
