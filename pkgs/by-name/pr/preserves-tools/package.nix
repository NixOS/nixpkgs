{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "preserves-tools";
  version = "4.994.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-+I2uxdAe4SHg8ZLRvkIUr862FH6GvCwnyhxcCPD3JBA=";
  };

  cargoHash = "sha256-09uxXD9EZzzk42tBYbuqaLRFyGmOUuvC7G0XMDjsK6E=";

  meta = {
    description = "Command-line utilities for working with Preserves documents";
    homepage = "https://preserves.dev/doc/preserves-tool.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "preserves-tool";
  };
}
