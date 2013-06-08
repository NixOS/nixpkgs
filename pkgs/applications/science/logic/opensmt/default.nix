x@{builderDefsPackage
  , automake, libtool, autoconf, intltool, perl
  , gmpxx, flex, bison
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="opensmt";
    version="20101017";
    name="${baseName}-${version}";
    filename="${baseName}_src_${version}";
    url="http://${baseName}.googlecode.com/files/${filename}.tgz";
    hash="0xrky7ixjaby5x026v7hn72xh7d401w9jhccxjn0khhn1x87p2w1";
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
  phaseNames = ["doAutotools" "doConfigure" "doMakeInstall"];
      
  meta = {
    description = "A satisfiability modulo theory (SMT) solver";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = "GPLv3";
    homepage = "http://code.google.com/p/opensmt/";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://code.google.com/p/opensmt/downloads/list";
    };
  };
}) x

