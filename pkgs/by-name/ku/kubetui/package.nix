{
  rustPlatform,
  lib,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "kubetui";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "sarub0b0";
    repo = "kubetui";
    tag = "v${version}";
    hash = "sha256-/gKz83IygwDcfE7AQbQCTfNT1vSRVvxyCz4JVAEcYoY=";
  };

  checkFlags = [
    "--skip=workers::kube::store::tests::kubeconfigからstateを生成"
  ];

  cargoHash = "sha256-W5EDeeK8oaubxgRnnuR7ef8XRvORGyv5xfSkSHZKIPc=";

  meta = {
    homepage = "https://github.com/sarub0b0/kubetui";
    changelog = "https://github.com/sarub0b0/kubetui/releases/tag/v${version}";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.mit;
    description = "Intuitive TUI tool for real-time monitoring and exploration of Kubernetes resources";
    mainProgram = "kubetui";
  };
}
