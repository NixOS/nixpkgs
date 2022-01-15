{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdzk";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mdzk-rs";
    repo = "mdzk";
    rev = version;
    sha256 = "sha256-NkoKQKcww5ktEbxbOY6WP8OemCB+rvXbuN9oSPjLE3Y=";
  };

  cargoSha256 = "sha256-uJ00tGiKtcYghFUh0fcYg4nZc/o8yhvlVs+6/aRNY5s=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Plain text Zettelkasten based on mdBook";
    homepage = "https://github.com/mdzk-rs/mdzk/";
    changelog = "https://github.com/mdzk-rs/mdzk/blob/main/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bryanasdev000 ratsclub ];
  };
}
