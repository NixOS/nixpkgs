{ stdenv, fetchurl, alsaLib, jackaudio, lv2, pkgconfig }:

stdenv.mkDerivation  rec {
  name = "setbfree-${version}";
  version = "0.7.5";

  src = fetchurl {
    url = "https://github.com/pantherb/setBfree/archive/v${version}.tar.gz";
    sha256 = "1chlmgwricc6l4kyg35vc9v8f1n8psr28iihn4a9q2prj1ihqcbc";
  };

  patchPhase = "sed 's#/usr/local#$(out)#g' -i common.mak";

  buildInputs = [ alsaLib jackaudio lv2 pkgconfig ];

  meta = with stdenv.lib; {
    description = "A DSP tonewheel organ emulator";
    homepage = http://setbfree.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
