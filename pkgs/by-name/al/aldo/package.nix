{
  lib,
  stdenv,
  fetchgit,
  libao,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aldo";
  version = "0.7.8";

  src = fetchgit {
    url = "git://git.savannah.gnu.org/aldo.git";
    tag = "v${finalAttrs.version}";
    sha256 = "0swvdq0pw1msy40qkpn1ar9kacqjyrw2azvf2fy38y0svyac8z2i";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libao ];

  meta = {
    description = "Morse code training program";
    homepage = "http://aldo.nongnu.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "aldo";
  };
})
