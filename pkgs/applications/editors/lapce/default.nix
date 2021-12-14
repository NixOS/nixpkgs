{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "lapce";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "lapce";
    repo = pname;
    rev = "v${version}";
    sha256 = "gmkdBvIzDqXydeVINlAu67wkxnMBEycVVB9aakfj6Aw=";
  };

  cargoSha256 = lib.fakeSha256;

  meta = with lib; {
    description = "Lightning-fast and Powerful Code Editor written in Rust";
    homepage = "https://github.com/lapce/lapce";
    license = licenses.asl20;
    maintainers = with maintainers; [
      alexnortung
    ];
  };
}
