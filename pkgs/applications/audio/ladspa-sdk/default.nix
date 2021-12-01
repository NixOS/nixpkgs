{ lib, stdenv, fetchurl }:
stdenv.mkDerivation rec {
  pname = "ladspa-sdk";
  version = "1.15";
  src = fetchurl {
    url = "https://www.ladspa.org/download/ladspa_sdk_${version}.tgz";
    sha256 = "1vgx54cgsnc3ncl9qbgjbmq12c444xjafjkgr348h36j16draaa2";
  };

  patchPhase = ''
    cd src
    sed -i 's@/usr/@$(out)/@g'  Makefile
    sed -i 's@-mkdirhier@mkdir -p@g'  Makefile
  '';

  meta = {
    description = "The SDK for the LADSPA audio plugin standard";
    longDescription = ''
      The LADSPA SDK, including the ladspa.h API header file,
      ten example LADSPA plugins and
      three example programs (applyplugin, analyseplugin and listplugins).
    '';
    homepage = "http://www.ladspa.org/ladspa_sdk/overview.html";
    license = lib.licenses.lgpl2;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
}
