{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "presenterm";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = "presenterm";
    rev = "v${version}";
    hash = "sha256-uwLVg/bURz2jLAQZgLujDR2Zewu5pcE9bwEBg/DQ4Iw=";
  };

  cargoHash = "sha256-tEgXqvSyScO/J/56ykCda3ERrTDQj5jCxlMEDof/fCA=";

  # Skip test that currently doesn't work
  checkFlags = [ "--skip=execute::test::shell_code_execution" ];

  meta = with lib; {
    description = "A terminal based slideshow tool";
    homepage = "https://github.com/mfontanini/presenterm";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mikaelfangel ];
    mainProgram = "presenterm";
  };
}
