{ mkDerivation, lib, fetchFromGitHub, cmake, pkg-config
, qtscript, poppler, hunspell
, withLua ? true, lua
, withPython ? true, python3 }:

mkDerivation rec {
  pname = "texworks";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "TeXworks";
    repo = "texworks";
    rev = "release-${version}";
    sha256 = "sha256-v0UukFM5brPtgq+zH5H1KfUc0eL0hjTC9z0tVQRqu2Q=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ qtscript poppler hunspell ]
                ++ lib.optional withLua lua
                ++ lib.optional withPython python3;

  cmakeFlags = lib.optional withLua "-DWITH_LUA=ON"
               ++ lib.optional withPython "-DWITH_PYTHON=ON";

  meta = with lib; {
    description = "Simple TeX front-end program inspired by TeXShop";
    homepage = "http://www.tug.org/texworks/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = with platforms; linux;
  };
}
