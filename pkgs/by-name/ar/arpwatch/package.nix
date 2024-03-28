{ fetchurl
, lib
, libpcap
, stdenv
, system-sendmail
, ...
}:
stdenv.mkDerivation rec {
  pname = "arpwatch";
  version = "3.6";

  src = fetchurl {
    url = "https://ee.lbl.gov/downloads/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-+GUp/lf9taL/VBO8E8JFBj+Zs790JCH9MTMnIXW+gVY=";
  };

  patchPhase = ''
    sed -i '1i#include <time.h>' report.c
  '';

  preInstall = ''
    install -d -m 0755 $out/bin
    install -d -m 0755 $out/etc/rc.d
    install -d -m 0755 $out/share/man/man8
  '';

  configureFlags = [ "--sbindir=${placeholder "out"}/bin" ];

  buildInputs = [ libpcap system-sendmail ];

  meta = with lib; {
    description = "Arpwatch tracks ethernet MAC addresses with their associated IP";
    homepage = "https://ee.lbl.gov/";
    license = licenses.bsd3;
    mainProgram = "arpwatch";
    maintainers = [ maintainers.nalves599 ];
  };
}
