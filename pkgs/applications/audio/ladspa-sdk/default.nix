{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "ladspa-sdk-${version}";
  version = "1.13";
  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/l/ladspa-sdk/ladspa-sdk_${version}.orig.tar.gz";
    sha256 = "0srh5n2l63354bc0srcrv58rzjkn4gv8qjqzg8dnq3rs4m7kzvdm";
  };

  patchPhase = ''
    cd src
    sed -i 's@/usr/@$(out)/@g'  makefile
    sed -i 's@-mkdirhier@mkdir -p@g'  makefile
  '';

  meta = {
    description = "The SDK for the LADSPA audio plugin standard";
    longDescription = ''
      The LADSPA SDK, including the ladspa.h API header file,
      ten example LADSPA plugins and
      three example programs (applyplugin, analyseplugin and listplugins).
    '';
    homepage = http://www.ladspa.org/ladspa_sdk/overview.html;
    license = stdenv.lib.licenses.lgpl2;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
