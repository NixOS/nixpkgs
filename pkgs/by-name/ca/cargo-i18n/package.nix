{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gettext,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-i18n";
  version = "0.2.13";

  src = fetchFromGitHub {
    owner = "kellpossible";
    repo = "cargo-i18n";
    rev = "v${version}";
    hash = "sha256-azwQlXsoCgNB/TjSBBE+taUR1POBJXaPnS5Sr+HVR90=";
  };

  cargoHash = "sha256-vN62QmCuhu7AjL6xSpBU6/ul4WgNLZbjWDCFyHj6rIM=";

  # Devendor gettext in the gettext-sys crate. The paths to the bin/lib/include folders have to be specified because
  # setting `GETTEXT_SYSTEM` only works on some platforms (i.e., not Darwin).
  env = {
    GETTEXT_BIN_DIR = "${lib.getBin gettext}/bin";
    GETTEXT_LIB_DIR = "${lib.getLib gettext}/lib";
    GETTEXT_INCLUDE_DIR = "${lib.getInclude gettext}/include";
  };

  cargoTestFlags = [ "--lib" ];

  meta = with lib; {
    description = "Rust Cargo sub-command and libraries to extract and build localization resources to embed in your application/library";
    homepage = "https://github.com/kellpossible/cargo-i18n";
    license = licenses.mit;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "cargo-i18n";
  };
}
