{ lib, stdenv, fetchurl, scons, boost, ladspaH, pkg-config }:

stdenv.mkDerivation rec {
  version = "0.2-2";
  pname = "nova-filters";

  src = fetchurl {
    url = "https://klingt.org/~tim/nova-filters/nova-filters_${version}.tar.gz";
    sha256 = "16064vvl2w5lz4xi3lyjk4xx7fphwsxc14ajykvndiz170q32s6i";
  };

  nativeBuildInputs = [ pkg-config scons ];
  buildInputs = [ boost ladspaH ];

  postPatch = ''
    # remove TERM:
    sed -i -e '4d' SConstruct
    sed -i "s@mfpmath=sse@mfpmath=sse -I ${boost.dev}/include@g" SConstruct
    sed -i "s/Options/Variables/g" SConstruct
    sed -i "s@ladspa.h@${ladspaH}/include/ladspa.h@g" filters.cpp
    sed -i "s@LADSPA_HINT_SAMPLE_RATE, 0, 0.5@LADSPA_HINT_SAMPLE_RATE, 0.0001, 0.5@g" filters.cpp
    sed -i "s/= check/= detail::filter_base<internal_type, checked>::check/" nova/source/dsp/filter.hpp
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "LADSPA plugins based on filters of nova";
    homepage = "https://tim.klingt.org/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
