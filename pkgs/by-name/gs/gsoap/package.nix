{ lib, stdenv, fetchurl, autoreconfHook, unzip, m4, bison, flex, openssl, zlib, buildPackages }:

let
  majorVersion = "2.8";
  isCross = stdenv.hostPlatform != stdenv.buildPlatform;

in stdenv.mkDerivation rec {
  pname = "gsoap";
  version = "${majorVersion}.108";

  src = fetchurl {
    url = "mirror://sourceforge/project/gsoap2/gsoap-${majorVersion}/gsoap_${version}.zip";
    sha256 = "0x58bwlclk7frv03kg8bp0pm7zl784samvbzskrnr7dl5v866nvl";
  };

  buildInputs = [ openssl zlib ];
  nativeBuildInputs = [ autoreconfHook bison flex m4 unzip ];
  # Parallel building doesn't work as of 2.8.49
  enableParallelBuilding = false;

  # Future versions of automake require subdir-objects if the source is structured this way
  # As of 2.8.49 (maybe earlier) this is needed to silence warnings
  prePatch = ''
    substituteInPlace configure.ac \
      --replace 'AM_INIT_AUTOMAKE([foreign])' 'AM_INIT_AUTOMAKE([foreign subdir-objects])'
    ${lib.optionalString isCross ''
      substituteInPlace gsoap/wsdl/Makefile.am \
        --replace-fail 'SOAP=$(top_builddir)/gsoap/src/soapcpp2$(EXEEXT)' 'SOAP=${lib.getExe' buildPackages.gsoap "soapcpp2"}'
    ''}
  '';

  meta = with lib; {
    description = "C/C++ toolkit for SOAP web services and XML-based applications";
    homepage = "http://www.cs.fsu.edu/~engelen/soap.html";
    # gsoap is dual/triple licensed (see homepage for details):
    # 1. gSOAP Public License 1.3 (based on Mozilla Public License 1.1).
    #    Components NOT covered by the gSOAP Public License are:
    #     - wsdl2h tool and its source code output,
    #     - soapcpp2 tool and its source code output,
    #     - UDDI code,
    #     - the webserver example code in gsoap/samples/webserver,
    #     - and several example applications in the gsoap/samples directory.
    # 2. GPLv2 covers all of the software
    # 3. Proprietary commercial software development license (removes GPL
    #    restrictions)
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor ];
  };
}
