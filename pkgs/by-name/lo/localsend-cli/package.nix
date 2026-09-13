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
    hash = "sha256-AmQVXGMVKLTOZ0HMi05ba/y4TmB56NlNvtGaKYvqt4o=";
  };

  cargoHash = "sha256-mdyWYfzS6YieY+dwQXREZJDo4PEKO5W9C3A3XGWoDKI=";

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
