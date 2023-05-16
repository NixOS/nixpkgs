<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, scons
, boost
, ladspaH
, libcxxabi
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nova-filters";
  version = "0.2-2";

  src = fetchurl {
    url = "https://klingt.org/~tim/nova-filters/nova-filters_${finalAttrs.version}.tar.gz";
    hash = "sha256-0WgxMDjhx2b39FKRwLrm8LrTO5nS0xE7+bRwQfcmBpg=";
  };

  postPatch = ''
    substituteInPlace SConstruct \
      --replace "'TERM' : os.environ['TERM']," "" \
      --replace "Options" "Variables" \
      --replace "-fomit-frame-pointer -ffast-math -mfpmath=sse" "-I${boost.dev}/include -I${ladspaH}/include" \
      --replace "env.has_key('cxx')" "True" \
      --replace "env['cxx']" "'${stdenv.cc.targetPrefix}c++'" \
      --replace "-Wl,--strip-all" "${lib.optionalString stdenv.isDarwin "-L${libcxxabi}/lib"}"

    substituteInPlace filters.cpp \
      --replace "LADSPA_HINT_SAMPLE_RATE, 0, 0.5" "LADSPA_HINT_SAMPLE_RATE, 0.0001, 0.5"

    substituteInPlace nova/source/dsp/filter.hpp \
      --replace "= check" "= detail::filter_base<internal_type, checked>::check"

    substituteInPlace nova/source/primitives/float.hpp \
      --replace "boost/detail/endian.hpp" "boost/predef/other/endian.h" \
      --replace "BOOST_LITTLE_ENDIAN" "BOOST_ENDIAN_LITTLE_BYTE"
  '';

  nativeBuildInputs = [
    scons
  ];

=======
{lib, stdenv, fetchurl, scons, boost, ladspaH, pkg-config }:

stdenv.mkDerivation {
  version = "0.2-2";
  pname = "nova-filters";

  src = fetchurl {
    url = "https://klingt.org/~tim/nova-filters/nova-filters_0.2-2.tar.gz";
    sha256 = "16064vvl2w5lz4xi3lyjk4xx7fphwsxc14ajykvndiz170q32s6i";
  };

  nativeBuildInputs = [ pkg-config scons ];
  buildInputs = [ boost ladspaH ];

  patchPhase = ''
    # remove TERM:
    sed -i -e '4d' SConstruct
    sed -i 's@Options@Variables@g' SConstruct
    sed -i "s@-fomit-frame-pointer -ffast-math -mfpmath=sse@-I ${boost.dev}/include@g" SConstruct
    sed -i "s@env.has_key('cxx')@'cxx' in env@g" SConstruct
    sed -i "s@ladspa.h@${ladspaH}/include/ladspa.h@g" filters.cpp
    sed -i "s@LADSPA_HINT_SAMPLE_RATE, 0, 0.5@LADSPA_HINT_SAMPLE_RATE, 0.0001, 0.5@g" filters.cpp
    sed -i "s/= check/= detail::filter_base<internal_type, checked>::check/" nova/source/dsp/filter.hpp
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "LADSPA plugins based on filters of nova";
    homepage = "http://klingt.org/~tim/nova-filters/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
<<<<<<< HEAD
    platforms = platforms.unix;
  };
})
=======
    platforms = platforms.linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
