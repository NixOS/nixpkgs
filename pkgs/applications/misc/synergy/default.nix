args: with args;
stdenv.mkDerivation {
  name = "synergy-cvs";

  # REGION AUTO UPDATE:          { name="synergy"; type = "cvs"; cvsRoot = ":pserver:anonymous@synergy2.cvs.sourceforge.net:/cvsroot/synergy2"; module="syngery"; }
  src = sourceFromHead "synergy-F_09-55-29.tar.gz"
               (fetchurl { url = "http://mawercer.de/~nix/repos/synergy-F_09-55-28.tar.gz"; sha256 = "443bb8cf8d4e365b2adaadd8770096fcafa0c54532e83f6a267eb3b05042b84c"; });
  # END
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
