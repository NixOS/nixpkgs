args: with args;
stdenv.mkDerivation {
  name = "synergy-cvs";

  src = fetchcvs {
    cvsRoot = ":pserver:anonymous@synergy2.cvs.sourceforge.net:/cvsroot/synergy2";
    module = "synergy";
    date = "NOW";
    sha256 = "ef8e2ebfda6e43240051a7af9417092b2af50ece8b5c6c3fbd908ba91c4fe068";
  };

  buildInputs = [x11 xextproto libXtst inputproto];

  meta= { 
      description = "share mouse keyboard and clipboard between computers";
      homepage = http://synergy2.sourceforge.net;
      license = "GPL";
  };
}
