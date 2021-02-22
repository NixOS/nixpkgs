{ mkDerivation, lib, fetchFromGitHub, fetchpatch, cmake, pkg-config
, qtscript, poppler, hunspell
, withLua ? true, lua
, withPython ? true, python3 }:

mkDerivation rec {
  pname = "texworks";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "TeXworks";
    repo = "texworks";
    rev = "release-${version}";
    sha256 = "1lw1p4iyzxypvjhnav11g6rwf6gx7kyzwy2iprvv8zzpqcdkjp2z";
  };

  patches = [
    (fetchpatch {
      name = "fix-compilation-with-qt-5.15.patch";
      url = "https://github.com/TeXworks/texworks/commit/a5352a3a94e3685125650b65e6197de060326cc2.patch";
      sha256 = "0pf7h1m11x0s039bxknm7rxdp9b4g8ch86y38jlyy56c74mw97i6";
    })
  ];

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
