{
  lib,
  stdenv,
  fetchurl,
  intltool,
  pkg-config,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "gnu-mdk";
  version = "1.3.0";
  src = fetchurl {
    url = "mirror://gnu/mdk/v${version}/mdk-${version}.tar.gz";
    sha256 = "0bhk3c82kyp8167h71vdpbcr852h5blpnwggcswqqwvvykbms7lb";
  };
  nativeBuildInputs = [
    pkg-config
    intltool
  ];
  buildInputs = [ glib ];
  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp -v ./misc/*.el $out/share/emacs/site-lisp
  '';

  meta = with lib; {
    description = "GNU MIX Development Kit (MDK)";
    homepage = "https://www.gnu.org/software/mdk/";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
