{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  sqlite,
  xdg-utils,
}:

rustPlatform.buildRustPackage rec {
  pname = "anup";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Acizza";
    repo = "anup";
    tag = version;
    hash = "sha256-4pXF4p4K8+YihVB9NdgT6bOidmQEgWXUbcbvgXJ0IDA=";
  };

  cargoHash = "sha256-925R5pG514JiA7iUegFkxrDpA3o7T/Ct4Igqqcdo3rw=";

  buildInputs = [
    sqlite
    xdg-utils
  ];

  meta = {
    homepage = "https://github.com/Acizza/anup";
    description = "Anime tracker for AniList featuring a TUI";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ natto1784 ];
    mainProgram = "anup";
  };
}
