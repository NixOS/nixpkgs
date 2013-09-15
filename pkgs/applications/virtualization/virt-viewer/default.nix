x@{builderDefsPackage
  , gnome, gtk, glib, libxml2, pkgconfig, libvirt, gtkvnc, cyrus_sasl, libtasn1
  , gnupg, libgcrypt, perl, nettle, yajl, libcap_ng
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    ["gnome"];

  buildInputs = (map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames)))
    ++ [gnome.libglade];
  sourceInfo = rec {
    baseName="virt-viewer";
    version="0.2.0";
    name="${baseName}-${version}";
    url="http://virt-manager.org/download/sources/${baseName}/${name}.tar.gz";
    hash="0lhkmp4kn0s2z8241lqf2fdi55jg9iclr5hjw3m4wzaznpiajwlp";
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
    description = "A viewer for remote virtual machines";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl2;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://virt-manager.org/download.html";
    };
  };
}) x

