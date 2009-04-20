{cabal, gtk2hs, binary, parsec, regexPosix, utf8String, libedit, makeWrapper}:

cabal.mkDerivation (self : {
  pname = "leksah";
  version = "0.4.4.1";
  sha256 = "092a8gi73jhalgs4ppg8ki761vwk3gdnjwlyd4chnahbv5i1wrjw";

  # !!! The explicit libedit dependency shouldn't be necessary.
  extraBuildInputs = [gtk2hs binary parsec regexPosix utf8String libedit makeWrapper];

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

