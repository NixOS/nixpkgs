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
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "curlpipe";
    repo = pname;
    rev = version;
    hash = "sha256-7rP/h3MlrMZl9yd655uRrnv1aUB57LzdyKs66wHp33Y=";
  };

  cargoHash = "sha256-z9pyMnYQZfCCVdVEakj3q27SFLahMDWRuAopYye6RIY=";

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
