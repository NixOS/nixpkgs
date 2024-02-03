{ lib
, stdenv
, fetchgit
, autoreconfHook
, pkg-config
, fltk13
, libsndfile
, gettext
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flamp";
  version = "2.2.09";

  src = fetchgit {
    url = "https://git.code.sf.net/p/fldigi/flamp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ev+Ik/e1zQGTH4FeiCDPHbrcXlctencEo4R0+M2Kg+g=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gettext
  ];

  buildInputs = [
    fltk13
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Digital modem program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ stteague ];
    platforms = platforms.unix;
    broken = stdenv.system == "x86_64-darwin";
  };
})
