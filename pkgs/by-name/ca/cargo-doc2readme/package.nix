{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitea,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-doc2readme";
  version = "0.7.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "msrd0";
    repo = "cargo-doc2readme";
    tag = finalAttrs.version;
    hash = "sha256-wkiUpU7AGZYwtlquPmgkJkyWBdQ0KqyDApMYetP48Y0=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  cargoHash = "sha256-GwVcV4bA8cHC9gmabrrRVT9J/IhFNlw8YdredJonCiY=";

  nativeBuildInputs = [ installShellFiles ];

  # Requires fetching crates from the network
  checkFlags = [ "--skip=tests/pass/multi-version" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cargo-doc2readme \
      --bash <($out/bin/cargo-doc2readme completion bash) \
      --fish <($out/bin/cargo-doc2readme completion fish) \
      --zsh <($out/bin/cargo-doc2readme completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Create a readme file containing the rustdoc comments from your code";
    longDescription = ''
      `cargo doc2readme` is a cargo subcommand to create a readme file
      to display on Codeberg, GitHub or crates.io, containing the
      rustdoc comments from your code.
    '';
    homepage = "https://codeberg.org/msrd0/cargo-doc2readme";
    changelog = "https://codeberg.org/msrd0/cargo-doc2readme/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "cargo-doc2readme";
  };
})
