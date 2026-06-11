{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rsass";
  version = "0.29.0";

  src = fetchCrate {
    pname = "rsass-cli";
    inherit (finalAttrs) version;
    hash = "sha256-3Xi+8TKmlZJYsZogzezce0KvasqTRfh04SmeC1UbJQ0=";
  };

  cargoHash = "sha256-TZZweDTF5sGdrCBXh42yaBMTI9ehjHGSFQu9HzVQEdA=";

  meta = {
    description = "Sass reimplemented in rust with nom";
    mainProgram = "rsass";
    homepage = "https://github.com/kaj/rsass";
    changelog = "https://github.com/kaj/rsass/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = [ ];
  };
})
