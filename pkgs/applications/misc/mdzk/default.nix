{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdzk";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "mdzk-rs";
    repo = "mdzk";
    rev = version;
    sha256 = "sha256-VUvV1XA9Bd3ugYHcKOcAQLUt0etxS/Cw2EgnFGxX0z0=";
  };

  cargoSha256 = "sha256-lZ4fc/94ESlhpfa5ylg45oZNeaF1mZPxQUSLZrl2V3o=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Plain text Zettelkasten based on mdBook";
    homepage = "https://github.com/mdzk-rs/mdzk/";
    changelog = "https://github.com/mdzk-rs/mdzk/blob/main/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bryanasdev000 ratsclub ];
  };
}
