{ lib, stdenv, fetchurl }:
stdenv.mkDerivation rec {
  pname = "ladspa.h";
  version = "1.15";
  src = fetchurl {
    url = "https://www.ladspa.org/download/ladspa_sdk_${version}.tgz";
    sha256 = "1vgx54cgsnc3ncl9qbgjbmq12c444xjafjkgr348h36j16draaa2";
  };

  installPhase = ''
    mkdir -p $out/include
    cp src/ladspa.h $out/include/ladspa.h
  '';

  meta = {
    description = "LADSPA format audio plugins header file";
    longDescription = ''
      The ladspa.h API header file from the LADSPA SDK.
      For the full SDK, use the ladspa-sdk package.
    '';
    homepage = "http://www.ladspa.org/ladspa_sdk/overview.html";
    license = lib.licenses.lgpl2;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.all;
  };
}
