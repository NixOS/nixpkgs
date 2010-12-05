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
    version="2.2";
    name="${baseName}-${version}";
    url="http://www.cs.nyu.edu/acsys/cvc3/releases/${version}/${name}.tar.gz";
    hash="1dw12d5vrixfr6l9j6j7026vrr22zb433xyl6n5yxx4hgfywi0ji";
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

