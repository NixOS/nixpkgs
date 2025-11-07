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
  version = "1.1.17";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-qf0SPFOfp180j6IHds6aQ2y0oYcwQWq7VrO8iyi7LXo=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  cargoHash = "sha256-AqrS+5y3bKuqAVvbmWDO3V0OBVSkW6212WQeY1hixsk=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
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
