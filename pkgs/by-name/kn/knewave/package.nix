{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "knewave";
  version = "2012-07-30";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "theleagueof";
    repo = "knewave";
    rev = "f335d5ff1f12e4acf97d4208e1c37b4d386e57fb";
    hash = "sha256-SaJU2GlxU7V3iJNQzFKg1YugaPsiJuSZpC8NCqtWyz0=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Bold, painted face for the rocker within";
    longDescription = ''
      Knewave is bold, painted face. Get it? Git it.
    '';
    homepage = "https://www.theleagueofmoveabletype.com/knewave";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ minijackson ];
  };
}
