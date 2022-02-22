{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdzk";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "mdzk-rs";
    repo = "mdzk";
    rev = version;
    sha256 = "sha256-UiJ28VI4qXo04WojNaExTVQ3aTIXCQrdMbNM0DDy8A4=";
  };

  cargoSha256 = "sha256-CiA8Z1+S6+Lwms70IiRvIN83gValHuy6kHOukR2O7/Q=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Plain text Zettelkasten based on mdBook";
    homepage = "https://github.com/mdzk-rs/mdzk/";
    changelog = "https://github.com/mdzk-rs/mdzk/blob/main/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bryanasdev000 ratsclub ];
  };
}
