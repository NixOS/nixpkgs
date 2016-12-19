{stdenv, fetchurl, scons, boost, ladspaH, pkgconfig }:

stdenv.mkDerivation rec {
  version = "0.2-2";
  name = "nova-filters-${version}";

  src = fetchurl {
    url = http://klingt.org/~tim/nova-filters/nova-filters_0.2-2.tar.gz;
    sha256 = "16064vvl2w5lz4xi3lyjk4xx7fphwsxc14ajykvndiz170q32s6i";
  };

  buildInputs = [ scons boost ladspaH pkgconfig ];

  patchPhase = ''
    # remove TERM:
    sed -i -e '4d' SConstruct
    sed -i "s@mfpmath=sse@mfpmath=sse -I ${boost.dev}/include@g" SConstruct
    sed -i "s@ladspa.h@${ladspaH}/include/ladspa.h@g" filters.cpp
    sed -i "s/= check/= detail::filter_base<internal_type, checked>::check/" nova/source/dsp/filter.hpp
  '';

  buildPhase = ''
    scons
  '';

  installPhase = ''
    scons $sconsFlags "prefix=$out" install
  '';

  meta = {
    homepage = http://klingt.org/~tim/nova-filters/;
    description = "LADSPA plugins based on filters of nova";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
