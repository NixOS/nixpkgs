x@{builderDefsPackage
  , flex, bison, gmp, perl
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    ["gmp"];

  buildInputs = (map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames)))
    ++ [(a.lib.overrideDerivation x.gmp (y: {dontDisableStatic=true;}))];
  sourceInfo = rec {
    baseName="cvc3";
    version="2.4.1";
    name="${baseName}-${version}";
    url="http://www.cs.nyu.edu/acsys/cvc3/releases/${version}/${name}.tar.gz";
    hash="1xxcwhz3y6djrycw8sm6xz83wb4hb12rd1n0skvc7fng0rh1snym";
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
  phaseNames = ["fixPaths" "doConfigure" "doMakeInstall"];
  fixPaths = a.fullDepEntry (''
    sed -e "s@ /bin/bash@bash@g" -i Makefile.std
    find . -exec sed -e "s@/usr/bin/perl@${perl}/bin/perl@g" -i '{}' ';'
  '') ["minInit" "doUnpack"];
      
  meta = {
    description = "A prover for satisfiability modulo theory (SMT)";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = "free-noncopyleft";
    homepage = "http://www.cs.nyu.edu/acsys/cvc3/index.html";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.cs.nyu.edu/acsys/cvc3/download.html";
    };
  };
}) x

