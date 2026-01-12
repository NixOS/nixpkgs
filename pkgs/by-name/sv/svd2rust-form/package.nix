{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "svd2rust-form";
  version = "0.13.0";

  src = fetchCrate {
    pname = "form";
    inherit (finalAttrs) version;
    hash = "sha256-7+5HEyP7480UM5dydavoiclX3YTvW46V8r+Vpqt4xWk=";
  };

  cargoHash = "sha256-ItNBQKye1GD01KFBubMLxksv8OCWIxya/LlZ9g6Jdg8=";

  meta = {
    description = "Library for splitting apart a large file with multiple modules into the idiomatic rust directory structure";
    mainProgram = "form";
    homepage = "https://github.com/djmcgill/form";
    changelog = "https://github.com/djmcgill/form/blob/main/CHANGELOG.md";
    license = with lib.licenses; [
      mit
    ];
    maintainers = with lib.maintainers; [ fidgetingbits ];
  };
})
