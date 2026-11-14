{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "fanwood";
  version = "2011-05-11";

  src = fetchFromGitHub {
    owner = "theleagueof";
    repo = "fanwood";
    rev = "cbaaed9704e7d37d3dcdbdf0b472e9efd0e39432";
    hash = "sha256-OroFhhb4RxPHkx+/8PtFnxs1GQVXMPiYTd+2vnRbIjg=";
  };

  outputs = [
    "out"
    "webfont"
  ];

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Serif based on the work of a famous Czech-American type designer of yesteryear";
    longDescription = ''
      Based on work of a famous Czech-American type designer of yesteryear. The
      package includes roman and italic.
    '';
    homepage = "https://www.theleagueofmoveabletype.com/fanwood";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ minijackson ];
  };
}
