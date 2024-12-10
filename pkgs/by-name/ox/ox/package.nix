{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "ox";
  version = "0.6.10";

  src = fetchFromGitHub {
    owner = "curlpipe";
    repo = pname;
    rev = version;
    hash = "sha256-7PaAcVatm/gqeZRuzCjoF6ZGDP6mIjDTuhmJQ5wt7x8=";
  };

  cargoHash = "sha256-2Jk8uDiTGUQqLOOQVlYm5R7qQXIqP0PkFvv5E5qTzT0=";

  meta = with lib; {
    description = "Independent Rust text editor that runs in your terminal";
    homepage = "https://github.com/curlpipe/ox";
    changelog = "https://github.com/curlpipe/ox/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ moni ];
    mainProgram = "ox";
  };
}
