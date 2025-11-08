{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  pkg-config,
  fltk13,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flamp";
  version = "2.2.14";

  src = fetchgit {
    url = "https://git.code.sf.net/p/fldigi/flamp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-y8x/0rLJSHL1B61ODtjmf2S6W7ChZasBfFE9lc66FSI=";
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
    mainProgram = "flamp";
  };
})
