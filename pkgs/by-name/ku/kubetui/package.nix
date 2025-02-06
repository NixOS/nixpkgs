{
  rustPlatform,
  lib,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "kubetui";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "sarub0b0";
    repo = "kubetui";
    tag = "v${version}";
    hash = "sha256-GCtcAoN/RjgaspTIR51TJQV2xT3dcVIFazITKVy7qYY=";
  };

  checkFlags = [
    "--skip=workers::kube::store::tests::kubeconfigからstateを生成"
  ];

  buildInputs = lib.optionals (stdenv.hostPlatform.isDarwin) (
    with darwin.apple_sdk;
    [
      frameworks.CoreGraphics
      frameworks.AppKit
    ]
  );
  cargoHash = "sha256-rS4P4CJ1V1Bq4lsprYEWhff9b1EqQ/6ytyjJs9DCrY0=";

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
