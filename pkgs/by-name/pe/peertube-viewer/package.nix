{ lib
, fetchFromGitLab
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "peertube-viewer";
  version = "1.8.5";

  src = fetchFromGitLab {
    owner = "peertube-viewer";
    repo = "peertube-viewer-rs";
    rev = "v1.8.5";
    hash = "sha256-GDglFi3BR0ojQi85XGysrIb1FR83FCDA2slyJJbhtjI=";
  };

  cargoHash = "sha256-TVXKtpFgvCJF2CYcT5X2Y3n/5LM7A/NZ81ye7FwnEJ0=";

  meta = with lib; {
    description = "A simple CLI browser for the peertube federated video platform";
    homepage = "https://gitlab.com/peertube-viewer/peertube-viewer-rs";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      haruki7049
    ];
  };
}
