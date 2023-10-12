{ lib
, stdenv
, fetchurl
, libnet
, libpcap
, libdnet
}:

stdenv.mkDerivation rec {
  pname = "firewalk";
  version = "5.0";

  src = fetchurl {
    url = "https://salsa.debian.org/pkg-security-team/firewalk/-/archive/debian/5.0-5/firewalk-debian-5.0-5.tar.gz";
    sha256 = "luFTi4DnXbiNDI2uPgbtF4Y9m/SdxQBs+Dfdmck7mFU=";
  };

  buildInputs = [ libnet libpcap libdnet ];

  meta = with lib; {
    description = "Gateway ACL scanner";
    homepage = "http://www.packetfactory.net/projects/firewalk/";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ tochiaha ];
    mainprogram = "firewalk";
  };
}

