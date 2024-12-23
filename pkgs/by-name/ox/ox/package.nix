{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  testers,
  nix-update-script,
  ox,
}:

rustPlatform.buildRustPackage rec {
  pname = "ox";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "curlpipe";
    repo = pname;
    rev = version;
    hash = "sha256-1RXvnYQ5nBVAraA43Tc62E3ppmZQL0BErxwGs80p7EU=";
  };

  cargoHash = "sha256-UxxPaa+iAOS2TI/+PMf48KpETZLZOhXD4ImsqupJAxw=";

  passthru = {
    tests.version = testers.testVersion {
      package = ox;
    };

    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Independent Rust text editor that runs in your terminal";
    homepage = "https://github.com/curlpipe/ox";
    changelog = "https://github.com/curlpipe/ox/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ moni ];
    mainProgram = "ox";
  };
}
