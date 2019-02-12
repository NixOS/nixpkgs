{stdenv, fetchurl, sconsPackages, boost, ladspaH, pkgconfig }:

stdenv.mkDerivation rec {
  version = "0.2-2";
  name = "nova-filters-${version}";

  src = fetchurl {
    url = https://klingt.org/~tim/nova-filters/nova-filters_0.2-2.tar.gz;
    sha256 = "16064vvl2w5lz4xi3lyjk4xx7fphwsxc14ajykvndiz170q32s6i";
  };

  nativeBuildInputs = [ pkgconfig sconsPackages.scons_3_0_1 ];
  buildInputs = [ boost ladspaH ];

  patchPhase = ''
    # remove TERM:
    sed -i -e '4d' SConstruct
    sed -i "s@mfpmath=sse@mfpmath=sse -I ${boost.dev}/include@g" SConstruct
    sed -i "s@ladspa.h@${ladspaH}/include/ladspa.h@g" filters.cpp
    sed -i "s@LADSPA_HINT_SAMPLE_RATE, 0, 0.5@LADSPA_HINT_SAMPLE_RATE, 0.0001, 0.5@g" filters.cpp
    sed -i "s/= check/= detail::filter_base<internal_type, checked>::check/" nova/source/dsp/filter.hpp
  '';

  meta = with stdenv.lib; {
    description = "LADSPA plugins based on filters of nova";
    homepage = http://klingt.org/~tim/nova-filters/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
