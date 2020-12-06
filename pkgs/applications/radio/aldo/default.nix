{ stdenv, fetchgit, libao, autoreconfHook }:

let
  pname = "aldo";
  version = "0.7.8";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchgit {
    url = "git://git.savannah.gnu.org/${pname}.git";
    rev = "v${version}";
    sha256 = "0swvdq0pw1msy40qkpn1ar9kacqjyrw2azvf2fy38y0svyac8z2i";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libao ];

  meta = with stdenv.lib; {
    description = "Morse code training program";
    homepage = "http://aldo.nongnu.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
