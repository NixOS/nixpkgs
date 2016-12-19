{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "ladspa.h-${version}";
  version = "1.13";
  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/l/ladspa-sdk/ladspa-sdk_${version}.orig.tar.gz";
    sha256 = "0srh5n2l63354bc0srcrv58rzjkn4gv8qjqzg8dnq3rs4m7kzvdm";
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
    homepage = http://www.ladspa.org/ladspa_sdk/overview.html;
    license = stdenv.lib.licenses.lgpl2;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.all;
  };
}
