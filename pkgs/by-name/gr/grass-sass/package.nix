{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "grass";
  version = "0.13.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-uk4XLF0QsH9Nhz73PmdSpwhxPdCh+DlNNqtbJtLWgNI=";
  };

  cargoHash = "sha256-2wJBYTOfaPBm+24ABl1cOs4W7UsRPYn70PSFDRRMCyU=";

  # tests require rust nightly
  doCheck = false;

  meta = {
    description = "Sass compiler written purely in Rust";
    homepage = "https://github.com/connorskees/grass";
    changelog = "https://github.com/connorskees/grass/blob/master/CHANGELOG.md#${
      lib.replaceStrings [ "." ] [ "" ] version
    }";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "grass";
  };
}
