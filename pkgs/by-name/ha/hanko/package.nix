{
  lib,
  fetchFromGitHub,
  installShellFiles,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "hanko";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "SRv6d";
    repo = "hanko";
    tag = "v${version}";
    hash = "sha256-9HRoXqZ3wdD6xf33tooEHiBWSZlggjUFomblwF4cFtA=";
  };

  cargoHash = "sha256-wHvhlWi99igZ2gKAIcBYg207JrbQNCOjlcVttIy3MV0=";

  passthru = {
    updateScript = nix-update-script { };
  };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage assets/manpages/*.1

    installShellCompletion assets/completions/hanko.bash
    installShellCompletion assets/completions/_hanko
    installShellCompletion assets/completions/hanko.fish
  '';

  meta = {
    description = "Keeps your Git allowed signers file up to date";
    homepage = "https://github.com/SRv6d/hanko";
    changelog = "https://github.com/SRv6d/hanko/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ srv6d ];
    mainProgram = "hanko";
  };
}
