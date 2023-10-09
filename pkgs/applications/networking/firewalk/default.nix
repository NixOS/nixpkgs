{ lib
, stdenv
, fetchurl
, libnet
, libpcap
, libdnet
}:

stdenv.mkDerivation rec {
    pname = "firewalk";
    version = "master";

    src = fetchurl {
        url = "https://salsa.debian.org/pkg-security-team/firewalk/-/archive/debian/master/firewalk-debian-master.tar.gz";
        hash = "sha256-d45Hm8WFTiVLPY2fPwnLdyapXLnBQaEJvzIgMdlzl08=";
    };

    buildInputs = [ libnet libpcap libdnet ];

    meta = with lib; {
        description = "A gateway ACL scanner";
        homepage = "https://salsa.debian.org/pkg-security-team/firewalk";
        licence = [  ];
        maintainers = with maintainers; [  ];
        platforms = platforms.linux;

    };
}
