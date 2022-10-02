{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkgs,
  libpanel
}:
rustPlatform.buildRustPackage rec {
  pname = "fm";
  version = "unstable-2022-06-08";

  src = fetchFromGitHub {
    owner = "euclio";
    repo = pname;
    rev = "3b78759dacdd5e5a375a3046bc4f41027388affe";
    sha256 = "sha256-NRHhuwcIAuYcHm05uRojeDOYzdsGW9JxLik69p4DA5M=";
  };

  cargoSha256 = "sha256-su1SWjXG9/h6BU7/pnP4fJ7+MpVqVN8cBZphDjfNoTU=";

  buildInputs = with pkgs; [
    glib
    libpanel
    libadwaita
    gtksourceview5
    gtk4
  ];
  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  meta = with lib; {
    description = "Small, general purpose file manager built with GTK4";
    homepage = "https://github.com/euclio/fm";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
