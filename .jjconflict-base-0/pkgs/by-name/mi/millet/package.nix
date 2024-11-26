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
    repo = pname;
    rev = "v${version}";
    hash = "sha256-V1FToLhBzeZd3ve+eKAHniHN6oveEg0FBHnkSZPxBqo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "chain-map-0.1.0" = "sha256-nds+lPGCbxw3GqrgfmTbKnPkiV3F6f5A2xr82qV33iI=";
      "sml-libs-0.1.0" = "sha256-zQrhH24XlA9SeQ+sVzaVwJwrm80TRIjFq99Vay7QEN8=";
    };
  };

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
