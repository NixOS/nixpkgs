{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig
, qt5, libsForQt5, hunspell
, withLua ? true, lua
, withPython ? true, python3 }:

stdenv.mkDerivation rec {
  pname = "texworks";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "TeXworks";
    repo = "texworks";
    rev = "release-${version}";
    sha256 = "1ljfl784z7dmh6f1qacqhc6qhcaqdzw033yswbvpvkkck0lsk2mr";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ qt5.qtscript libsForQt5.poppler hunspell ]
                ++ lib.optional withLua lua
                ++ lib.optional withPython python3;

  cmakeFlags = lib.optional withLua "-DWITH_LUA=ON"
               ++ lib.optional withPython "-DWITH_PYTHON=ON";

  meta = with stdenv.lib; {
    description = "Simple TeX front-end program inspired by TeXShop";
    homepage = http://www.tug.org/texworks/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = with platforms; linux;
  };
}
