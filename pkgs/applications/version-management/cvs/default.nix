{ stdenv, fetchurl, nano }:

stdenv.mkDerivation {
  name = "cvs-1.12.13";

  src = fetchurl {
    url = http://ftp.gnu.org/non-gnu/cvs/source/feature/1.12.13/cvs-1.12.13.tar.bz2;
    sha256 = "0pjir8cwn0087mxszzbsi1gyfc6373vif96cw4q3m1x6p49kd1bq";
  };

  buildInputs = [ nano ];
}
