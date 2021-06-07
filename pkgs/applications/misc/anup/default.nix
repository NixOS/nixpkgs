{ lib, rustPlatform, fetchFromGitHub, sqlite, xdg_utils }:

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
    sqlite.dev
    xdg_utils
  ];

  cargoSha256 = "sha256-1TA2HDHKA3twFtlAWaC2zcRzS8TJwcbBt1OTQ3hC3qM=";

  meta = with lib; {
    description = "An anime tracker for AniList featuring a TUI";
    license = licenses.agpl3Only;
    homepage = "https://github.com/Acizza/anup";
    maintainers = with maintainers; [ natto1784 ];
    platforms = platforms.linux;
  };
}
