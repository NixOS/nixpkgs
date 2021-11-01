{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdzk";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "mdzk-rs";
    repo = "mdzk";
    rev = version;
    sha256 = "sha256-yz8lLFAP2/16fixknqGziyrUJKs3Qo1+whV82kUPuAE=";
  };

  cargoSha256 = "sha256-TGNzi8fMU7RhX2SJyxpYfJLgGYxpO/XkmDXzMdlX/2o=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Plain text Zettelkasten based on mdBook";
    homepage = "https://github.com/mdzk-rs/mdzk/";
    changelog = "https://github.com/mdzk-rs/mdzk/blob/main/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bryanasdev000 ratsclub ];
  };
}
