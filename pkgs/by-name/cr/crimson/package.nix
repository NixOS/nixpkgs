{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "crimson";
  version = "2014.10";

  src = fetchFromGitHub {
    owner = "skosch";
    repo = "Crimson";
    rev = "fonts-october2014";
    hash = "sha256-Wp9L77q93TRmrAr0P4iH9gm0tqFY0X/xSsuFcd19aAE=";
  };

  outputs = [
    "out"
    "webfont"
  ];

  nativeBuildInputs = [ installFonts ];

  postInstall = ''
    install -m444 -Dt $out/share/doc/${pname}-${version} README.md
  '';

  meta = {
    homepage = "https://github.com/skosch/Crimson";
    description = "Font family inspired by beautiful oldstyle typefaces";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.rycee ];
  };
}
