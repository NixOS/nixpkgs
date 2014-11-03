x@{builderDefsPackage
  , gmp, bison, perl, autoconf, ncurses, readline
  , coreutils
  , ...}:
builderDefsPackage
(a :
let
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="Singular";
    version="3-1-2";
    revision="-1";
    name="${baseName}-${version}${revision}";
    url="http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/${version}/${name}.tar.gz";
    hash="04f9i1xar0r7qrrbfki1h9rrmx5y2xg4w7rrvlbx05v2dy6s8djv";
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
  phaseNames = ["doFixPaths" "doConfigure" "doMakeInstall" "fixInstall"];
  doFixPaths = a.fullDepEntry (''
    find . -exec sed -e 's@/bin/rm@${a.coreutils}&@g' -i '{}' ';'
    find . -exec sed -e 's@/bin/uname@${a.coreutils}&@g' -i '{}' ';'
  '') ["minInit" "doUnpack"];
  fixInstall = a.fullDepEntry (''
    rm -rf "$out/LIB"
    cp -r Singular/LIB "$out"
    mkdir -p "$out/bin"
    ln -s "$out/"*/Singular "$out/bin"
  '') ["minInit" "defEnsureDir"];

  meta = {
    description = "A CAS for polynomial computations";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.stdenv.lib.licenses.gpl3; # Or GPLv2 at your option - but not GPLv4
    homepage = "http://www.singular.uni-kl.de/index.php";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/";
    };
  };
}) x
