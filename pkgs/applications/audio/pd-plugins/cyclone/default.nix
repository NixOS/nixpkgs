{ stdenv, fetchurl, puredata }:

stdenv.mkDerivation rec {
  name = "cyclone-${version}";
  version = "0.1-alpha55";

  src = fetchurl {
    url = "mirror://sourceforge/project/pure-data/libraries/cyclone/${name}.tar.gz";
    sha256 = "1yys9xrlz09xgnqk2gqdl8vw6xj6l9d7km2lkihidgjql0jx5b5i";
  };

  buildInputs = [ puredata ];

  patchPhase = ''
    for file in `grep -r -l g_canvas.h`
      do
        sed -i 's|#include "g_canvas.h"|#include "${puredata}/include/pd/g_canvas.h"|g' $file
      done
    for file in `grep -r -l m_imp.h`
      do
        sed -i 's|#include "m_imp.h"|#include "${puredata}/include/pd/m_imp.h"|g' $file
      done
  '';

  installPhase = ''
    mkdir -p $out/cyclone
    cp -r bin/* $out/cyclone
  '';

  meta = {
    description = "A library of PureData classes, bringing some level of compatibility between Max/MSP and Pd environments";
    homepage = http://puredata.info/downloads/cyclone;
    license = stdenv.lib.licenses.tcltk;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
