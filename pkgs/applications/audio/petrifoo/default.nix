{ lib, stdenv, fetchurl, fetchpatch, alsa-lib, cmake, gtk2, libjack2, libgnomecanvas
, libpthreadstubs, libsamplerate, libsndfile, libtool, libxml2
, pkg-config, openssl }:

stdenv.mkDerivation  rec {
  pname = "petri-foo";
  version = "0.1.87";

  src = fetchurl {
    url =  "mirror://sourceforge/petri-foo/${pname}-${version}.tar.bz2";
    sha256 = "0b25iicgn8c42487fdw32ycfrll1pm2zjgy5djvgw6mfcaa4gizh";
  };

  patches = [
    # Pull patch pending upstream inclusion for -fno-common toollchain support:
    #  https://github.com/petri-foo/Petri-Foo/pull/43
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/petri-foo/Petri-Foo/commit/6a3256c9b619b1fed18ad15063f110e8d91aa6fe.patch";
      sha256 = "05yc4g22iwnd054jmvihrl461yr0cxnghslfrbhan6bac6fcvlal";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ alsa-lib gtk2 libjack2 libgnomecanvas libpthreadstubs
                  libsamplerate libsndfile libtool libxml2 openssl ];

  meta = with lib; {
    description = "MIDI controllable audio sampler";
    longDescription = "a fork of Specimen";
    homepage = "https://petri-foo.sourceforge.net";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "petri-foo";
  };
}
