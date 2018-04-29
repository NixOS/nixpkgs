{ stdenv, fetchFromGitHub, qmake, pkgconfig, qtwebkit, hunspell }:

stdenv.mkDerivation rec {
  pname = "ghostwriter";
  version = "1.6.2";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "wereturtle";
    repo = pname;
    rev = "v${version}";
    sha256 = "0251563zy0q69fzfacvalpx43y15cshb0bhshyd4w37061gh1c12";
  };

  nativeBuildInputs = [ qmake pkgconfig ];

  buildInputs = [ qtwebkit hunspell ];

  meta = with stdenv.lib; {
    description = "A cross-platform, aesthetic, distraction-free Markdown editor";
    homepage = src.meta.homepage;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
  };
}
