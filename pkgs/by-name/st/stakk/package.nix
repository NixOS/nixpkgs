{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  cacert,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stakk";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "glennib";
    repo = "stakk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wu7qyGF+FY1j6tx24jCs9wi+MtdmZEHOMioWqUXLPek=";
  };

  cargoHash = "sha256-Mxd/DVXFP5YarR3HuV8d6eFW9Dma0qdwC1DlD1vLGO4=";

  useNextest = true;
  # The forgejo transport tests build a reqwest client, which needs a CA bundle.
  nativeCheckInputs = [ cacert ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    installShellFiles
    versionCheckHook
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd stakk \
      --bash <($out/bin/stakk completions bash) \
      --fish <($out/bin/stakk completions fish) \
      --zsh <($out/bin/stakk completions zsh) \
  '';

  passthru.updateScript = nix-update-script { };
  __structuredAttrs = true;

  meta = {
    description = "Bridge Jujutsu (jj) bookmarks to GitHub stacked pull requests";
    homepage = "https://github.com/glennib/stakk";
    changelog = "https://github.com/glennib/stakk/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      voidlily
      Br1ght0ne
    ];
    mainProgram = "stakk";
  };
})
