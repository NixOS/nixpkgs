{
  lib,
  rustPackages,
  fetchFromGitHub,
  pkg-config,
}:

rustPackages.rustPlatform.buildRustPackage rec {
  pname = "hawkeye";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "korandoru";
    repo = "hawkeye";
    tag = "v${version}";
    hash = "sha256-wT6c2wA31+xFcgPUp4djuvsHxwWyEderQTPSzLLqeAg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qWn9duoGmYVHGBnjT57/m2BT/yc9BNUGHSn748ZmAzg=";

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    homepage = "https://github.com/korandoro/hawkeye";
    description = "Simple license header checker and formatter, in multiple distribution forms";
    license = lib.licenses.asl20;
    mainProgram = "hawkeye";
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
}
