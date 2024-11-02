{
  rustPlatform,
  lib,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "kubetui";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "sarub0b0";
    repo = "kubetui";
    rev = "refs/tags/v${version}";
    hash = "sha256-0K0h/MaQClJDqgF0qQO2INb+hpzxfSikAti+751MX/8=";
  };

  checkFlags = [
    "--skip=workers::kube::store::tests::kubeconfigからstateを生成"
  ];

  buildInputs = lib.optionals (stdenv.isDarwin) (
    with darwin.apple_sdk;
    [
      frameworks.CoreGraphics
      frameworks.AppKit
    ]
  );
  cargoHash = "sha256-kfAErXqjdLn2jaCtr+eI0+0v4TcE8Hpx0DDECnuYp5w=";

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
