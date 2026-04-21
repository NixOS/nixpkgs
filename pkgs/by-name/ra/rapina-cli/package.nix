{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rapina-cli";
  version = "0.11.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-zdhyXJUSg8wU65YMXZBqDIkkGTh9DjSbc7b63pU2nuo=";
  };

  cargoHash = "sha256-wcYGBXs08I3E1/7Obx9E3BXmU5nFV0NBfWoALxHa4SI=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Rapina CLI is a command-line tool designed to streamline the process of generating and managing Rapina projects";
    homepage = "https://userapina.com";
    changelog = "https://github.com/rapina-rs/rapina/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ apetrovic6 ];
    mainProgram = "rapina";
  };
})
