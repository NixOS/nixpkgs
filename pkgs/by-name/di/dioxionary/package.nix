{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dioxionary";
  version = "1.2.0";
  src = fetchFromGitHub {
    owner = "vaaandark";
    repo = "dioxionary";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xIieWhT/a5dZ+UPfsMWtgwru5nkUdzr8/0pOiqCSnqo=";
    # enable fetchSubmodules since the tests require dictionaries from the submodules
    fetchSubmodules = true;
  };

  cargoHash = "sha256-YFx8V86awxVUX83bNLHRP6nIBZGHck/0ywriBgVqvxY=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];
  buildInputs = [ openssl.dev ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd dioxionary \
      --bash <($out/bin/dioxionary completion bash) \
      --zsh <($out/bin/dioxionary completion zsh) \
      --fish <($out/bin/dioxionary completion fish)
  '';

  checkFlags = [
    # skip these tests since they require internet access
    "--skip=dict::online::test::look_up_online_by_chinese"
    "--skip=dict::online::test::look_up_online_by_english"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rusty stardict. Enables terminal-based word lookup and vocabulary memorization using offline or online dictionaries";
    homepage = "https://github.com/vaaandark/dioxionary";
    changelog = "https://github.com/vaaandark/dioxionary/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ulic-youthlic ];
    mainProgram = "dioxionary";
  };
})
