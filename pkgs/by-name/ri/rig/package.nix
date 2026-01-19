{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  version = "1.11";
  pname = "rig";

  src = fetchurl {
    url = "https://ayera.dl.sourceforge.net/project/rig/rig/${version}/rig-${version}.tar.gz";
    sha256 = "1f3snysjqqlpk2kgvm5p2icrj4lsdymccmn3igkc2f60smqckgq0";
  };

  # Note: diff modified from Debian: Norbert Veber <nveber@debian.org>
  # http://deb.debian.org/debian/pool/main/r/rig/rig_1.11-1.diff.gz
  patches = [ ./rig_1.11-1.diff ];

  makeFlags = [ "CXX=${stdenv.cc.targetPrefix}c++" ];

  meta = {
    homepage = "https://rig.sourceforge.net/";
    description = "Random identity generator";
    longDescription = ''
      RIG (Random Identity Generator) is a free replacement for a shareware
      program out there called 'fake'. It generates random, yet real-looking,
      personal data. It is useful if you need to feed a name to a Web site,
      BBS, or real person, and are too lazy to think of one yourself. Also,
      if the Web site/BBS/person you are giving the information to tries to
      cross-check the city, state, zip, or area code, it will check out.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ tomberek ];
    platforms = with lib.platforms; all;
    mainProgram = "rig";
  };
}
