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

  meta = with lib; {
    description = "LADSPA plugins based on filters of nova";
    homepage = "http://klingt.org/~tim/nova-filters/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
})
