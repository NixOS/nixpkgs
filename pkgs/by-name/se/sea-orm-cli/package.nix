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
  version = "1.1.7";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-/Wer+3uNWk9p/l1uVpMLEXrDQ/PB+rcpWPi6tuhucSo=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-9o8HT5GNeqGQqzrDhSzzwoeo//MYV1YPec98j8UMHv4=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
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
