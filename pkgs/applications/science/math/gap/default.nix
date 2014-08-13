x@{builderDefsPackage
  , pari ? null
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
    pkgVer="2012_01_12-10_47_UTC";
    pkgURL="ftp://ftp.gap-system.org/pub/gap/gap4/tar.bz2/packages-${pkgVer}.tar.bz2";
    pkgHash="0z9ncy1m5gvv4llkclxd1vpcgpb0b81a2pfmnhzvw8x708frhmnb";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  pkgSrc = a.fetchurl {
    url=sourceInfo.pkgURL;
    sha256=sourceInfo.pkgHash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMake" "doDeploy"];

  doDeploy = a.fullDepEntry ''
    mkdir -p "$out/bin" "$out/share/gap/"

    cp -r . "$out/share/gap/build-dir"

    tar xf "${pkgSrc}" -C "$out/share/gap/build-dir/pkg"

    ${if a.pari != null then
      ''sed -e '2iexport PATH=$PATH:${pari}/bin' -i "$out/share/gap/build-dir/bin/gap.sh" ''
    else ""}
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
    license = with a.lib.licenses;
      gpl2;
    homepage = "http://gap-system.org/";
  };
}) x
