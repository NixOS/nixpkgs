{
  lib,
  rustPackages,
  fetchFromGitHub,
  pkg-config,
}:

rustPackages.rustPlatform.buildRustPackage rec {
  pname = "hawkeye";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "korandoru";
    repo = "hawkeye";
    tag = "v${version}";
    hash = "sha256-VfJWj9BwNVR7RVUW+CjFuaniyiEath1U0F/7QJcA3r4=";
  };

  cargoHash = "sha256-tTXoxWjcTtEcRcuSs0ewCN1VJYmTIKRgL3s7QSYt7sk=";

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
