{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "sea-orm-cli";
  version = "1.1.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-4j4jeZBe4HyPpa8Em4/zPcIjlJmGfymyEJP2PfDdELQ=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  cargoHash = "sha256-ZdKDQUBpFEVBvvGCulRH+riTeLoXGMMBn2RGSL1uUy4=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;
  __darwinAllowLocalNetworking = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    mainProgram = "sea-orm-cli";
    homepage = "https://www.sea-ql.org/SeaORM";
    description = "Command line utility for SeaORM";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ traxys ];
  };
}
