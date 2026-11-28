{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "localsend-cli";
  version = "1.19.0";
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "localsend";
    repo = "localsend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9HDKDdYhiDow71C3xlgkBNnTFKM18QoTa3YADh6Dz88=";
  };

  cargoHash = "sha256-Wkkn+gpYcvmYTVejwuq9PfVsfFm3IwwZQpRUuC7Ir8M=";

  buildAndTestSubdir = "cli";

  meta = {
    description = "Open source cross-platform alternative to AirDrop, CLI version.";
    homepage = "https://localsend.org/";
    donationPage = "https://localsend.org/donate";
    downloadPage = "https://github.com/localsend/localsend/releases";
    changelog = "https://github.com/localsend/localsend/blob/HEAD/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "localsend-cli";
    maintainers = with lib.maintainers; [
      sachin-sankar
    ];
  };
})
