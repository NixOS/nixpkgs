{
  lib,
  stdenv,
  fetchzip,
  pkg-config,
  lv2,
  gtkmm2,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "lv2-cpp-tools";
  version = "1.0.5";

  src = fetchzip {
    url = "http://deb.debian.org/debian/pool/main/l/lv2-c++-tools/lv2-c++-tools_${version}.orig.tar.bz2";
    sha256 = "039bq7d7s2bhfcnlsfq0mqxr9a9iqwg5bwcpxfi24c6yl6krydsi";
  };

  preConfigure = ''
    sed -r 's,/bin/bash,${stdenv.shell},g' -i ./configure
    sed -r 's,/sbin/ldconfig,ldconfig,g' -i ./Makefile.template
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    lv2
    gtkmm2
    boost
  ];

  meta = with lib; {
    homepage = "http://ll-plugins.nongnu.org/hacking.html";
    description = "Tools and libraries that may come in handy when writing LV2 plugins in C++";
    license = licenses.gpl3;
    maintainers = [ maintainers.michalrus ];
    platforms = platforms.linux;
  };
}
