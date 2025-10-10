{
  rustPlatform,
  lib,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "kubetui";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "sarub0b0";
    repo = "kubetui";
    tag = "v${version}";
    hash = "sha256-2bcFame21oj8kYJaGiBHcZspplLIDuag64AbLGwOvQs=";
  };

  checkFlags = [
    "--skip=workers::kube::store::tests::kubeconfigからstateを生成"
  ];

  cargoHash = "sha256-PzGlTTx5cVnMoUx0VQi+s8VHNV/PJDu6bm1TZuHbaoE=";

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
