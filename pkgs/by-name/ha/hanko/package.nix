{
  lib,
  fetchFromGitHub,
  installShellFiles,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hanko";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "SRv6d";
    repo = "hanko";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tmspfsIIxYa9fTPhHJrVRUcpC8gZ0R4prTLTDstuwbg=";
  };

  cargoHash = "sha256-IcQtG29qTQl4U0HwG+kvPT07RhSgUADtejV7ObWyjG0=";

  # Upstream tests require network access, which is unavailable in the sandbox.
  doCheck = false;

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
})
