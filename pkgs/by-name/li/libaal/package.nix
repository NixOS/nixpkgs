{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  version = "1.0.7";
  pname = "libaal";

  src = fetchurl {
    url = "mirror://sourceforge/reiser4/${pname}-${version}.tar.gz";
    sha256 = "sha256-fIVohp2PVCaNaQRVJ4zfW8mukiiqM3BgF8Vwu9qrmJE=";
  };

  preInstall = ''
    substituteInPlace Makefile --replace ./run-ldconfig true
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://www.namesys.com/";
    description = "Support library for Reiser4";
    license = licenses.gpl2;
    maintainers = with maintainers; [ mglolenstine ];
    platforms = with platforms; linux;
  };
}
