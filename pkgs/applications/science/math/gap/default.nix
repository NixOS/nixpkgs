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
    baseName="gap";
    version="4r4p12";
    name="${baseName}-${version}";
    url="ftp://ftp.gap-system.org/pub/gap/gap4/tar.gz/${baseName}${version}.tar.gz";
    hash="0flap5lbkvpms3zznq1zwxyxyj0ax3fk7m24f3bvhvr37vyxnf40";
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
  phaseNames = ["doConfigure" "doMake" "doDeploy"];

  doDeploy = a.fullDepEntry ''
    ensureDir "$out/bin" "$out/share/gap/"

    cp -r . "$out/share/gap/build-dir"

    sed -e "/GAP_DIR=/aGAP_DIR='$out/share/gap/build-dir/'" -i "$out/share/gap/build-dir/bin/gap.sh" 

    ln -s "$out/share/gap/build-dir/bin/gap.sh" "$out/bin"
  '' ["doMake" "minInit" "defEnsureDir"];
      
  meta = {
    description = "Computational discrete algebra system";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = "GPLv2+";
    homepage = "http://gap-system.org/";
  };
}) x

