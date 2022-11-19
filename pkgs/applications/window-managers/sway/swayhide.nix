 {
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "swayhide";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "NomisIV";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ICDz3oDuXl/DAO4njoLJuv7hRXt76nGPPQlBVcc+hZo=";
  };

  cargoSha256 = "sha256-N3fuBnz8kKO5ncwbVx7ED4ufmXoTY6zNiW+8UcJigCA=";

  meta = with lib; {
    description = "A window swallower for swaywm";
    homepage    = "https://github.com/NomisIV/swayhide/";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ luftmensch-luftmensch ];
    platforms   = platforms.linux;
  };
}
