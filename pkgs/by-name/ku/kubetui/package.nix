{
  rustPlatform,
  lib,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "kubetui";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "sarub0b0";
    repo = "kubetui";
    tag = "v${version}";
    hash = "sha256-CtKckAmvXdH+CU+nV1hNGhemOCj5HRkAEQDSMD32CFE=";
  };

  checkFlags = [
    "--skip=workers::kube::store::tests::kubeconfigからstateを生成"
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-+O22eo2vj4WLbSQoUfGOOfp2a43j2RrVXvB7CmYRA1o=";

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
