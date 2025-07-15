{
  lib,
  rustPackages,
  fetchFromGitHub,
  pkg-config,
}:

rustPackages.rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hawkeye";
  version = "6.0.4";

  src = fetchFromGitHub {
    owner = "korandoru";
    repo = "hawkeye";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kIHeyNmtrkYZ+o0HojM0N1RhPEeTf+ADMTOvZzjFDLs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-yf2oIpekE8pjxvPpvwEbHJ/jK6HwUMm1RupwLnK4Q4U=";

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
