# I haven't put much effort into this expressions .. so some optional depencencies may be missing - Marc
args:
args.stdenv.mkDerivation {
  name = "lyx-1.5.3";

  src = args.fetchurl {
    url = http://lyx.cybermirror.org/stable/lyx-1.5.3.tar.bz2;
    sha256 = "1q0xlhrvj87iw9rk9z2vfka4jw5pw7n5fsmmiyzram9y4hghavav";
  };

  buildInputs =(with args; [tetex qt python]);

  meta = { 
      description = "WYSIWYM frontend for LaTeX, DocBook, etc.";
      homepage = "http://www.lyx.org";
      license = "GPL2";
  };
}
