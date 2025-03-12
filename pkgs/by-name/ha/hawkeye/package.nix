{
  lib,
  rustPackages,
  fetchFromGitHub,
  pkg-config,
}:

rustPackages.rustPlatform.buildRustPackage rec {
  pname = "hawkeye";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "korandoru";
    repo = "hawkeye";
    tag = "v${version}";
    hash = "sha256-vf4Y/OJ6owLC3AMm4LVUyc/kfUluxN5VxC07hDWuEQY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-mGJuAuq2z7JXRgAIVrBaO75Je++lBHHTUowo7+LEuaE=";

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
