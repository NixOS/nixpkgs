{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sea-orm-cli";
  version = "2.0.3";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-cmNpT+UWb8J29fIyYxJ4UB7LdMkFk9EFJOWOV7M2HHI=";
  };

  cargoHash = "sha256-ztH9PDN9fYPinBy5TC8TK2DHSvR6koYlec90Y0Mzo28=";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

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
    changelog = "https://github.com/SeaQL/sea-orm/releases/tag/sea-orm-cli%40${finalAttrs.version}";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      traxys
      anish
    ];
  };
})
