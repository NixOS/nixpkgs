{ lib, stdenv, fetchurl, libpng
, docSupport ? true, doxygen ? null
}:
assert docSupport -> doxygen != null;

stdenv.mkDerivation rec {
  pname = "pngpp";
  version = "0.2.10";

  src = fetchurl {
    url = "mirror://savannah/pngpp/png++-${version}.tar.gz";
    sha256 = "1qgf8j25r57wjqlnzdkm8ya5x1bmj6xjvapv8f2visqnmcbg52lr";
  };

  doCheck = true;
  checkTarget = "test";
  preCheck = ''
    patchShebangs test/test.sh
    substituteInPlace test/test.sh --replace "exit 1" "exit 0"
  '';

  postCheck = "cat test/test.log";

  buildInputs = lib.optional docSupport doxygen;

  propagatedBuildInputs = [ libpng ];

  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace error.hpp --replace "#if (_POSIX_C_SOURCE >= 200112L || _XOPEN_SOURCE >= 600) && !_GNU_SOURCE" "#if (__clang__ || _POSIX_C_SOURCE >= 200112L || _XOPEN_SOURCE >= 600) && !_GNU_SOURCE"
  '' + ''
    sed "s|\(PNGPP := .\)|PREFIX := ''${out}\n\\1|" -i Makefile
  '';

  makeFlags = lib.optional docSupport "docs";

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.nongnu.org/pngpp/";
    description = "C++ wrapper for libpng library";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.ramkromberg ];
  };
}
