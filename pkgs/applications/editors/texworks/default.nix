{ mkDerivation, lib, fetchFromGitHub, cmake, pkg-config
, qtscript, poppler, hunspell
, withLua ? true, lua
, withPython ? true, python3 }:

mkDerivation rec {
  pname = "texworks";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "TeXworks";
    repo = "texworks";
    rev = "release-${version}";
    sha256 = "0d7f23c6c1wj4aii4h5w9piv01qfb69zrd79dvxwydrk99i8gnl4";
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
