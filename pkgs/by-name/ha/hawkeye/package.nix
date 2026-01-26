{
  lib,
  rustPackages,
  fetchFromGitHub,
  pkg-config,
}:

rustPackages.rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hawkeye";
  version = "6.4.1";

  src = fetchFromGitHub {
    owner = "korandoru";
    repo = "hawkeye";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k+FXv4TJuIgsgFaci3I5HTgjd7PeLJDpPGCH6Tx81Kw=";
  };

  cargoHash = "sha256-T2OH/dbs0SXk/0PkUImv3jq71Z1luhTbjsb/sSr5yBY=";

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    homepage = "https://github.com/korandoru/hawkeye";
    description = "Simple license header checker and formatter, in multiple distribution forms";
    license = lib.licenses.asl20;
    mainProgram = "hawkeye";
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
})
