{ stdenv, fetchurl, qtbase, qtsvg, qmakeHook, boost }:

stdenv.mkDerivation rec {
  version = "0.9.0b";
  name = "fritzing-${version}";

  src = fetchurl {
    url = "http://fritzing.org/download/${version}/source-tarball/fritzing-${version}.source.tar_1.bz2";
    sha256 = "181qnknq1j5x075icpw2qk0sc4wcj9f2hym533vs936is0wxp2gk";
  };

  buildInputs = [ qtbase qtsvg boost qmakeHook ];

  meta = {
    description = "An open source prototyping tool for Arduino-based projects";
    homepage = http://fritzing.org/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.robberer ];
  }; 
}
