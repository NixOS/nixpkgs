{
  rustPlatform,
  lib,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kubetui";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "sarub0b0";
    repo = "kubetui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KhO9MY1TIf27Wh10OhUsaxgFghSTwO8yJ/n9/a0cqzE=";
  };

  checkFlags = [
    "--skip=workers::kube::store::tests::kubeconfigからstateを生成"
  ];

  cargoHash = "sha256-BwKAyDtvxzpAce2m4DGBVMhJCcSTnxfBoN0IJH0rRnM=";

  meta = {
    homepage = "https://github.com/sarub0b0/kubetui";
    changelog = "https://github.com/sarub0b0/kubetui/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.mit;
    description = "Intuitive TUI tool for real-time monitoring and exploration of Kubernetes resources";
    mainProgram = "kubetui";
  };
})
