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
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "curlpipe";
    repo = pname;
    rev = version;
    hash = "sha256-kTCdq3C0OUQS3tQRwEJ0+MTHZ8j2nnUARjdbmfH6ed4=";
  };

  cargoHash = "sha256-GiKSkpXEngQtnGW8zjy2RWQOG1b/xQrYRSLHsndkooo=";

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
