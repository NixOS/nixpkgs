{ stdenv, fetchurl, alsaLib, python, SDL }:

stdenv.mkDerivation rec {
  version = "20120105";
  name = "schismtracker-${version}";

  src = fetchurl {
    url = "http://schismtracker.org/dl/${name}.tar.bz2";
    sha256 = "1ny7wv2wxm1av299wvpskall6438wjjpadphmqc7c0h6d0zg5kii";
  };

  preConfigure = ''
    # Build fails on Linux with windres.
    export ac_cv_prog_ac_ct_WINDRES=
  '';

  configureFlags = [ "--enable-dependency-tracking" ];

  buildInputs = [ alsaLib python SDL ];

  enableParallelBuilding = true;

  meta = {
    description = "Music tracker application, free reimplementation of Impulse Tracker";
    homepage = http://schismtracker.org/;
    license = stdenv.lib.licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = [ stdenv.lib.maintainers.ftrvxmtrx ];
  };
}
