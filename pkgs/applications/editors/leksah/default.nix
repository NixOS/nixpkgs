{cabal, gtk2hs, binary, parsec, regexPosix, regexCompat, utf8String, libedit, makeWrapper}:

cabal.mkDerivation (self : {
  pname = "leksah";
  version = "0.6.1";
  sha256 = "de4e0974be3df0e58fd26bfbb76594d81514f1e1d898b9f47881b42084bacf35";

  # !!! The explicit libedit dependency shouldn't be necessary.
  extraBuildInputs = [gtk2hs binary parsec regexPosix regexCompat utf8String libedit makeWrapper];

  preConfigure =
    ''
      substituteInPlace leksah.cabal --replace 'Cabal ==1.6.0.1' 'Cabal >=1.6.0.1' 
    '';

  postInstall =
    ''
      wrapProgram $out/bin/leksah --prefix XDG_DATA_DIRS : ${gtk2hs.gtksourceview}/share
    '';
  
  meta = {
    homepage = http://leksah.org/;
    description = "An Integrated Development Environment for Haskell written in Haskell";
  };
})  

