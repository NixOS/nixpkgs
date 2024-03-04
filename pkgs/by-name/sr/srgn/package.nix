{ lib
, fetchFromGitHub
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "srgn";
  # the latest versioned release has broken unit tests, so we use the latest commit instead
  version = "0.10.2-unstable-2024-02-04";

  src = fetchFromGitHub {
    owner = "alexpovel";
    repo = "srgn";
    rev = "9df9fe772df140c2cd0f3c8311c1e12c210838de";
    hash = "sha256-qUkuE0Tws7pl0Hd9Dsi6+V74ErCv+BwdvTdCbvAjgIc=";
  };

  cargoHash = "sha256-B0epxhyPoImoclQRQHVgKPxnEdb8ER2mjJgse7FtgqU=";

  meta = with lib; {
    description = "A code surgeon for precise text and code transplantation.";
    homepage = "https://github.com/NixOS/nixpkgs/issues/293066";
    license = licenses.mit;
    maintainers = with maintainers; [ binarycat ];
    mainProgram = "srgn";
  };
}
