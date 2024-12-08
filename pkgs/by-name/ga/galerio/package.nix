{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "galerio";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "dbrgn";
    repo = "galerio";
    rev = "v${version}";
    hash = "sha256-JR/YfMUs5IHBRr3uYqHXLNcr23YHyDvgH2y/1ip+2Y8=";
  };

  cargoHash = "sha256-nYaCN09LP/2MfNRY8oZKtjzFCBFCeRF1IZ2ZBmbHg7I=";

  meta = with lib; {
    description = " A simple generator for self-contained HTML flexbox galleries";
    homepage = "https://github.com/dbrgn/galerio";
    maintainers = with maintainers; [ dbrgn ];
    license = with licenses; [ asl20 mit ];
    mainProgram = "galerio";
  };
}
