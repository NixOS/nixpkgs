{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig
, qt5, libsForQt5, hunspell
, withLua ? true, lua
, withPython ? true, python }:

stdenv.mkDerivation rec {
  name = "texworks-${version}";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "TeXworks";
    repo = "texworks";
    rev = "release-${version}";
    sha256 = "0kj4pq5h4vs2wwg6cazxjlv83x6cwdfsa76winfkdddaqzpdklsj";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ qt5.qtscript libsForQt5.poppler hunspell lua python ]
                ++ lib.optional withLua lua
                ++ lib.optional withPython python;

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
