{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "linja-pi-pu-lukin";
  version = "0-unstable-2022-04-03";

  src = fetchFromGitHub {
    owner = "janSa-tp";
    repo = "linja-pi-pu-lukin";
    rev = "50e285e2e670a5e1be743bb93a4bf90590a437cc";
    hash = "sha256-gUjmDBW4Av4B5hyoMIGgdBlFdoiRlyCNROvOVZ8/4BY=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Sitelen pona font resembling the style found in Toki Pona: The Language of Good (lipu pu), by jan Sa";
    homepage = "https://jansa-tp.github.io/linja-pi-pu-lukin/";
    license = lib.licenses.unfree; # license is unspecified in repository
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ somasis ];
  };
}
