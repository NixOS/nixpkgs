{
  lib,
  rustPlatform,
  sydbox,
  pandora,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "pandora";
  version = "0.14.0";

  src = sydbox.src.override {
    tag = "pandora-${version}";
    hash = "sha256-u5v3UwCK4UleHM7YcGZfCo6aYbfZQJLPRC6qcviKwuQ=";
  };
  sourceRoot = "${src.name}/pandora";

  useFetchCargoVendor = true;
  cargoHash = "sha256-5xRpRWpeD2C3fFbSWWp+ZQ17FJIAs3cNQQ28dnRkhC0=";

  passthru = {
    tests.version = testers.testVersion {
      package = pandora;
      command = "pandora -V";
    };
  };

  meta = {
    inherit (sydbox.meta) homepage license maintainers;
    description = "Syd's log inspector & profile writer";
    changelog = "https://gitlab.exherbo.org/sydbox/sydbox/-/raw/pandora-${version}/pandora/ChangeLog.md";
    mainProgram = "pandora";
    platforms = lib.platforms.linux;
  };
}
