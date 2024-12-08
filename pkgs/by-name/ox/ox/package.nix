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
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "curlpipe";
    repo = pname;
    rev = version;
    hash = "sha256-yAToibHhvHAry7WVZ5uD84CbUTp06RyZ9J12/2deM1I=";
  };

  cargoHash = "sha256-YAy5vCxcHUL0wM9+Y3GDqV/V1utL3V05heT92/zQ/X8=";

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
