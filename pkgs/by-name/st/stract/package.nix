{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  curl,
}:

rustPlatform.buildRustPackage rec {
  pname = "stract";
  version = "0-unstable-2024-09-14";

  src = fetchFromGitHub {
    owner = "StractOrg";
    repo = "stract";
    rev = "21d28ea86d9ff19ccb4c25b1bdde67e5ec302d79";
    hash = "sha256-7Uvo5+saxwTMQjfDliyOYC6j6LbpMf/FiONfX38xepI=";
  };

  cargoHash = "sha256-7Skbeeev/xBAhlcyOsYpDJB9LnZpT66D0Fu1I/jIBso=";

  cargoDepsName = "stract";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    curl
  ];

  meta = {
    description = "Open source web search engine hosted at stract.com targeted towards tinkerers and developers.";
    homepage = "https://github.com/StractOrg/stract";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ailsa-sun ];
  };
}
