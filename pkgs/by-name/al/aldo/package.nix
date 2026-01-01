{
  lib,
  stdenv,
  fetchgit,
  libao,
  autoreconfHook,
}:

let
  pname = "aldo";
  version = "0.7.8";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchgit {
    url = "git://git.savannah.gnu.org/${pname}.git";
    tag = "v${version}";
    sha256 = "0swvdq0pw1msy40qkpn1ar9kacqjyrw2azvf2fy38y0svyac8z2i";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libao ];

<<<<<<< HEAD
  meta = {
    description = "Morse code training program";
    homepage = "http://aldo.nongnu.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Morse code training program";
    homepage = "http://aldo.nongnu.org/";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "aldo";
  };
}
