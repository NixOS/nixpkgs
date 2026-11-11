{
  lib,
  fetchFromGitHub,
  installShellFiles,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hanko";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "marvinvogt";
    repo = "hanko";
    tag = "v${finalAttrs.version}";
    hash = "sha256-raQl8inNOO9pRQnlESrQ5dSbQG7uC3LtQIv8AOqD+e0=";
  };

  cargoHash = "sha256-EuYJX1Ds4Kq2Vka5gDnFHRHl3F20xMDm2XgYy4+FZXE=";

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
    homepage = "https://github.com/marvinvogt/hanko";
    changelog = "https://github.com/marvinvogt/hanko/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ srv6d ];
    mainProgram = "hanko";
  };
})
