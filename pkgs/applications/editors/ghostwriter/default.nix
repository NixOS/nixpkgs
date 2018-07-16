{ stdenv, fetchFromGitHub, qmake, pkgconfig, qtwebkit, hunspell }:

stdenv.mkDerivation rec {
  pname = "ghostwriter";
  version = "1.7.0";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "wereturtle";
    repo = pname;
    rev = "v${version}";
    sha256 = "00nlk5gazlfnndanhhjj5hlvkkp9yfx5mj6jq0jz37mk8mn6rzln";
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
