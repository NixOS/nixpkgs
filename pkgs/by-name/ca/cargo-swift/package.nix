{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-swift";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "antoniusnaumann";
    repo = "cargo-swift";
    rev = "v${finalAttrs.version}";
    hash = "sha256-42Ssc75VKhVaIgvQxaq7zzKY41DyRrwzf3/ePVA57SY=";
  };

  cargoHash = "sha256-jbOTbJmlQioi3+RFkJN6ig66hoDzqmtylHKbllCySd0=";

  meta = {
    description = "Cargo plugin to easily build Swift packages from Rust code";
    mainProgram = "cargo-swift";
    homepage = "https://github.com/antoniusnaumann/cargo-swift";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ elliot ];
  };
})
