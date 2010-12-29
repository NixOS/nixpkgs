x@{builderDefsPackage
  , guile, pkgconfig, glib, loudmouth, gmp, libidn, readline, libtool
  , libunwind, ncurses
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="freetalk";
    version="3.2";
    name="${baseName}-${version}";
    url="mirror://savannah/${baseName}/${name}.tar.gz";
    hash="12dn7yj9k5xsrrjlnma77wzpvsdxjccwla1q0wy3lacl5l2p0jms";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  patches = [./01_callbacks_const_fix.diff];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doPatch" "doConfigure" "doMakeInstall"];
      
  meta = {
    description = "Console XMPP client";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl3Plus;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.gnu.org/software/freetalk/";
    };
  };
}) x

