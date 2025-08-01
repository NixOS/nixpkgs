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
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "bilelmoussaoui";
    repo = "oo7";
    rev = version;
    hash = "sha256-P20hxwTT/O4o+Z1LnXJJkeEHv1IILfj4/pPMNde55mY=";
  };

  # TODO: this won't cover tests from the client crate
  # Additionally cargo-credential will also not be built here
  buildAndTestSubdir = "cli";

  cargoHash = "sha256-VNgbdvX5ttW+/V2Zzkd3rGIjVe1ENRE6WLg7M48ij7o=";

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
