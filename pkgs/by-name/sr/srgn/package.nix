{ lib
, fetchFromGitHub
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "srgn";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "alexpovel";
    repo = "srgn";
    rev = "srgn-v${version}";
    hash = "sha256-szOknySy7P/ZYVCJceg4eQtOf3wshQR2zHWqhqcvpNA=";
  };

  cargoHash = "sha256-vGBe0yZP+FwGDY9JTV4rP6ESmPerzYg27g7+9SNDOAw=";

  # currently, the tests try to run `git restore`, which fails.
  doCheck = false;

  meta = with lib; {
    description = "A code surgeon for precise text and code transplantation.";
    homepage = "https://github.com/NixOS/nixpkgs/issues/293066";
    license = licenses.mit;
    maintainers = with maintainers; [ binarycat ];
    mainProgram = "srgn";
  };
}
