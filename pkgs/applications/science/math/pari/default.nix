x@{builderDefsPackage
  , perl, zlib, gmp, readline
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="pari";
    version="2.3.5";
    name="${baseName}-${version}";
    url="http://pari.math.u-bordeaux.fr/pub/pari/unix/${name}.tar.gz";
    hash="124xr2jdz2c15v45i1zvgylng44lhf23729a1mk7ci1vywdaxpa7";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
  configureCommand="./Configure";
      
  meta = {
    description = "Computer algebra system for high-performance number theory computations";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = "GPLv2+";
    homepage = "http://pari.math.u-bordeaux.fr/";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://pari.math.u-bordeaux.fr/download.html";
    };
  };
}) x

