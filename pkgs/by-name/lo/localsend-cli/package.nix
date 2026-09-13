{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cacert,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "localsend-cli";
  version = "1.18.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "localsend";
    repo = "localsend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hP4whBkBQ/FEnUOjgeC+HIzrWhtbME6HGxmwwvTSSeI=";
  };

  cargoHash = "sha256-lgg+f7gLHUG4pYUAJW+nIrS8vUX4x+daupgCG8jct/Q=";

  # required for tests
  nativeBuildInputs = [ cacert ];

  # skip the `server` binary
  cargoBuildFlags = [
    "--bin"
    "localsend-cli"
  ];

  meta = {
    description = "Open source cross-platform alternative to AirDrop (CLI version)";
    homepage = "https://localsend.org/";
    donationPage = "https://localsend.org/donate";
    downloadPage = "https://github.com/localsend/localsend/releases";
    changelog = "https://github.com/localsend/localsend/blob/HEAD/CHANGELOG.md";

    mainProgram = "localsend-cli";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];

    maintainers = [ lib.maintainers.olimoli ];
  };
})
