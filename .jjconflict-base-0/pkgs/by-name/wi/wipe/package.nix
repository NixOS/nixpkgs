{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "wipe";
  version = "2.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/wipe/${version}/${pname}-${version}.tar.bz2";
    sha256 = "180snqvh6k6il6prb19fncflf2jcvkihlb4w84sbndcv1wvicfa6";
  };

  patches = [ ./fix-install.patch ];

  meta = with lib; {
    description = "Secure file wiping utility";
    mainProgram = "wipe";
    homepage = "https://wipe.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.abbradar ];
  };
}
