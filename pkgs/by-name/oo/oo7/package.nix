{
  fetchFromGitHub,
  lib,
  nix-update-script,
  oo7,
  pkg-config,
  rustPlatform,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "oo7";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "bilelmoussaoui";
    repo = "oo7";
    rev = version;
    hash = "sha256-4QEFlQJt2qMf1SxP4OUP2rkmx6OjvNJ/tibuwZLRwus=";
  };

  # TODO: this won't cover tests from the client crate
  # Additionally cargo-credential will also not be built here
  buildAndTestSubdir = "cli";

  useFetchCargoVendor = true;
  cargoHash = "sha256-WqEHYywkFcHyoT55IuTFt5tfeeEtVhNc7VhuEc0nFfk=";

  nativeBuildInputs = [ pkg-config ];

  passthru = {
    tests.testVersion = testers.testVersion { package = oo7; };

    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "James Bond went on a new mission as a Secret Service provider";
    homepage = "https://github.com/bilelmoussaoui/oo7";
    changelog = "https://github.com/bilelmoussaoui/oo7/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [
      getchoo
      Scrumplex
    ];
    platforms = platforms.linux;
    mainProgram = "oo7-cli";
  };
}
