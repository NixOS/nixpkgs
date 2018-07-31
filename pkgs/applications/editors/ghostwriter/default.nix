{ stdenv, fetchFromGitHub, qmake, pkgconfig, qtwebkit, hunspell }:

stdenv.mkDerivation rec {
  pname = "ghostwriter";
  version = "1.7.2";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "wereturtle";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zhzibn4g79i98mjfqspf3iac2biz3r18jf29g0izq5snn7xj0fc";
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
