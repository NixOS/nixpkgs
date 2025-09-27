{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libtool,
  gtk3,
  libpcap,
  popt,
  itstool,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "etherape";
  version = "0.9.21";
  src = fetchurl {
    url = "mirror://sourceforge/etherape/etherape-${version}.tar.gz";
    sha256 = "sha256-SckN87uIDTxg36xERMqPxdaLqPNrgg7V+Hc4HJoHF1w=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    itstool
    pkg-config
    (lib.getBin libxml2)
  ];
  buildInputs = [
    libtool
    gtk3
    libpcap
    popt
  ];

  meta = with lib; {
    homepage = "https://etherape.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ symphorien ];
  };
}
