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
  version = "1.1.19";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-dsise5MDhR4pcD3ZWDUzTG0Q4Fg/VdKw2Q59/g6BabA=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  cargoHash = "sha256-38KIJYwRvVmChGSJwaRRWbb/HPuuTp/qnvXpo3xjRpE=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  __darwinAllowLocalNetworking = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    mainProgram = "sea-orm-cli";
    homepage = "https://www.sea-ql.org/SeaORM";
    description = "Command line utility for SeaORM";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [ traxys ];
  };
}
