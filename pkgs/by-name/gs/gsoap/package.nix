{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  unzip,
  m4,
  bison,
  flex,
  openssl,
  zlib,
  buildPackages,
}:

let
  isCross = stdenv.hostPlatform != stdenv.buildPlatform;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "gsoap";
  version = "2.8.143";

  src = fetchurl {
    url = "mirror://sourceforge/gsoap2/gsoap_${finalAttrs.version}.zip";
    hash = "sha256-tTgVhMvIWRB4szmtoVn7BgWGwOHkZmtotKOVjvLisek=";
  };

  buildInputs = [
    openssl
    zlib
  ];
  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    m4
    unzip
  ];
  # Parallel building doesn't work as of 2.8.49
  enableParallelBuilding = false;

  prePatch = ''
    ${lib.optionalString isCross ''
      substituteInPlace gsoap/wsdl/Makefile.am \
        --replace-fail 'SOAP=$(top_builddir)/gsoap/src/soapcpp2$(EXEEXT)' 'SOAP=${lib.getExe' buildPackages.gsoap "soapcpp2"}'
    ''}
  '';

  meta = {
    description = "C/C++ toolkit for SOAP web services and XML-based applications";
    homepage = "https://www.genivia.com/products.html";
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
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      bjornfor
      veprbl
    ];
  };
})
