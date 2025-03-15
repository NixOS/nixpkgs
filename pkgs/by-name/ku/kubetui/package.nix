{
  rustPlatform,
  lib,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "kubetui";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "sarub0b0";
    repo = "kubetui";
    tag = "v${version}";
    hash = "sha256-sEl/hkGn9X0NArCMA1Nr+KM5mR8ZXAl4hBiU8zGaS0U=";
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
  useFetchCargoVendor = true;
  cargoHash = "sha256-1wc2mXX2NQdFaygukeaSDn6qHUaBcTRvCo0uSX289s0=";

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
