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
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = "nix-your-shell";
    tag = "v${version}";
    hash = "sha256-FjGjLq/4qeZz9foA7pfz1hiXvsdmbnzB3BpiTESLE1c=";
  };

  cargoHash = "sha256-zQpK13iudyWDZbpAN8zm9kKmz8qy3yt8JxT4lwq4YF0=";

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
