a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "3.4" a; 
  buildInputs = with a; [
    aalib gsl libpng libX11 xproto libXext xextproto 
    libXt zlib gettext intltool perl
  ];
in
rec {
  src = fetchurl {
    url = "http://prdownloads.sourceforge.net/xaos/XaoS-${version}.tar.gz";
    sha256 = "004cdb0xv14shyixs79bf95s52s7aidr5bqfn9wb49gpasrsknrc";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["preConfigure" "doConfigure" "doMakeInstall"];

  preConfigure = a.fullDepEntry (''
    sed -e s@/usr/@"$out/"@g -i configure $(find . -name 'Makefile*')
    ensureDir $out/share/locale
  '') ["doUnpack" "minInit" "defEnsureDir"];
      
  name = "xaos-" + version;
  meta = {
    description = "XaoS - fractal viewer";
  };
}
