{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "sn-pro";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "supernotes";
    repo = "sn-pro";
    rev = version;
    hash = "sha256-H8YG7FMn03tiBxz5TZDzowicqtewfX6rYd03pdTPYSo=";
  };

  outputs = [
    "out"
    "webfont"
  ];

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "SN Pro Font Family";
    homepage = "https://github.com/supernotes/sn-pro";
    license = lib.licenses.ofl;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
