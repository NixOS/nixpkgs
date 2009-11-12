args: with args;
stdenv.mkDerivation {
  name = "synergy-cvs";

  src = bleedingEdgeRepos.sourceByName "synergy";
  /*
  fetchcvs {
    cvsRoot = ":pserver:anonymous@synergy2.cvs.sourceforge.net:/cvsroot/synergy2";
    module = "synergy";
    date = "NOW";
    sha256 = "0a52b3adaae5f41cf16c5911c9037c5f2ee704a27bcaa9f874e3a4ff58d773c1";
  };
  */

  buildInputs = [x11 xextproto libXtst inputproto libXi];

  patches = [ (fetchurl {
    url = http://mawercer.de/~nix/syncergy-gcc43.patch.gz;
    sha256 = "12kla0nii6qc9fy5x4dc4qisfcyl9dqnrj5y911davnvwkwlj18h";
  }) ];

  meta= { 
      description = "share mouse keyboard and clipboard between computers";
      homepage = http://synergy2.sourceforge.net;
      license = "GPL";
  };
}
