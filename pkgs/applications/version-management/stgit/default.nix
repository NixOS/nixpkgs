args:
args.stdenv.mkDerivation {
  name = "stgit-0.14.3";

  src = args.fetchurl {
    url = http://homepage.ntlworld.com/cmarinas/stgit/stgit-0.14.3.tar.gz;
    sha256 = "13gcvz6x91m2860n26xp12j0xsshzvwij03sfzm5g3ckm18ffkw7";
  };

  buildInputs =(with args; [python git]);

  buildPhase = "true";
  
  installPhase = "
    python ./setup.py install --prefix=$out
  ";

  meta = { 
      description = "quilt for git (stacking patches)";
      homepage = http://procode.org/stgit/;
      license = "GPL";
  };
}
