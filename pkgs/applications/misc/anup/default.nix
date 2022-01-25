{ lib, stdenv, rustPlatform, fetchFromGitHub, Security, sqlite, xdg-utils}:

rustPlatform.buildRustPackage rec {
  pname = "anup";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Acizza";
    repo = "anup";
    rev = version;
    sha256 = "sha256-4pXF4p4K8+YihVB9NdgT6bOidmQEgWXUbcbvgXJ0IDA=";
  };

  buildInputs = [
    sqlite
    xdg-utils
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  cargoSha256 = "sha256-1TA2HDHKA3twFtlAWaC2zcRzS8TJwcbBt1OTQ3hC3qM=";

  meta = with lib; {
    homepage = "https://github.com/Acizza/anup";
    description = "An anime tracker for AniList featuring a TUI";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ natto1784 ];
  };
}
