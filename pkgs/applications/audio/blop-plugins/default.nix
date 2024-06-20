{ lib, stdenv, fetchurl, ladspa-sdk, ... }:

stdenv.mkDerivation rec {
  pname = "blop-plugins";
  version = "0.2.8";

  src = fetchurl {
    url = "http://prdownloads.sourceforge.net/blop/blop-${version}.tar.gz";
    sha256 = "sha256-focTT6xCjSw6REIxGeJz0YnvCO419Ic9fYjWRhCvPgo=";
  };

  buildInputs = [ ladspa-sdk ];

  configureFlags = [
    "--with-ladspa-plugin-dir=$(out)/lib/ladspa"
    "--with-ladspa-prefix=${ladspa-sdk}"
  ];

  meta = with lib; {
    description = "BLOP LADSPA plugins";
    longDescription = ''
        BLOP comprises a set of LADSPA plugins that generate bandlimited sawtooth, square,
        variable pulse and slope-variable triangle waves, principally for use with one of
        the many modular software synthesisers available. They are wavetable based, and
        are designed to produce output with harmonic content as high as possible over a
        wide pitch range. Additionally, there are a few extra plugins to assist in
        building synthesis networks.
    '';
    homepage = "http://blop.sourceforge.net/index.html";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.fps ];
  };
}
