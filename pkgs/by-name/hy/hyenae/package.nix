{
  lib,
  stdenv,
  fetchurl,
  libdnet,
  pkg-config,
  libpcap,
}:

stdenv.mkDerivation rec {
  pname = "hyenae";
  version = "0.36-1";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "mirror://sourceforge/hyenae/${version}/hyenae-${version}.tar.gz";
    sha256 = "1f3x4yn9a9p4f4wk4l8pv7hxfjc8q7cv20xzf7ky735sq1hj0xcg";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libdnet
    libpcap
  ];

  meta = with lib; {
    description = "";
    homepage = "https://sourceforge.net/projects/hyenae/";
    license = licenses.gpl3;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
