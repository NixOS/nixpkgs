{
  lib,
  rustPackages,
  fetchFromGitHub,
  pkg-config,
}:

rustPackages.rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hawkeye";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "korandoru";
    repo = "hawkeye";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F+6zbVr3oUD/HMpTa5nDR9Tv/k9v+R644IFhVNfKwuU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-BPSA0Z6Bk05xvztv1btkErC4+WDUcIWs7aFV2eVySwQ=";

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
