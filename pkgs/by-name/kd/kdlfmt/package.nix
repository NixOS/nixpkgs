{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kdlfmt";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "hougesen";
    repo = "kdlfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VHcpF9CTRDl9dtX/rZeDKVoCerI1sNjwURBpiE9bH80=";
  };

  cargoHash = "sha256-A8pp4IWL8hR4G1WDNFo6e3BVRxuVjfazIKOwCEGN7Rc=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kdlfmt \
      --bash <($out/bin/kdlfmt completions bash) \
      --fish <($out/bin/kdlfmt completions fish) \
      --zsh <($out/bin/kdlfmt completions zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Formatter for kdl documents";
    homepage = "https://github.com/hougesen/kdlfmt";
    changelog = "https://github.com/hougesen/kdlfmt/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      airrnot
      defelo
    ];
    mainProgram = "kdlfmt";
  };
})
