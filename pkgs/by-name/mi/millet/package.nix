{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "millet";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = "millet";
    rev = "v${version}";
    hash = "sha256-V1FToLhBzeZd3ve+eKAHniHN6oveEg0FBHnkSZPxBqo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-49dJ1USxdGK8WmPmO3z8Tkexjn4xi+qJRxawqFeIQBg=";

  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoBuildFlags = [
    "--package"
    "millet-ls"
  ];

  cargoTestFlags = [
    "--package"
    "millet-ls"
  ];

  meta = with lib; {
    description = "Language server for Standard ML";
    homepage = "https://github.com/azdavis/millet";
    changelog = "https://github.com/azdavis/millet/blob/v${version}/docs/CHANGELOG.md";
    license = [
      licenses.mit # or
      licenses.asl20
    ];
    maintainers = [ ];
    mainProgram = "millet-ls";
  };
}
