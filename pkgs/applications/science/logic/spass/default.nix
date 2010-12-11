x@{builderDefsPackage
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="spass";
    baseVersion="3";
    minorVersion="7";
    version="${baseVersion}.${minorVersion}";
    name="${baseName}-${version}";
    url="http://www.spass-prover.org/download/sources/${baseName}${baseVersion}${minorVersion}.tgz";
    hash="1k5a98kr3vzga54zs7slwwaaf6v6agk1yfcayd8bl55q15g7xihk";
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
      
  meta = {
    description = "An automated theorem preover for FOL";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = "BSD";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.spass-prover.org/download/index.html";
    };
  };
}) x

