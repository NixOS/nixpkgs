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

  useFetchCargoVendor = true;
  cargoHash = "sha256-SJEl5QsO4KYRv+5xDPHy1Q53qcL89IJ9JTXtzubO5fk=";

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
