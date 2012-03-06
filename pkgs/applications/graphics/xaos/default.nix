a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "3.5" a; 
  buildInputs = with a; [
    aalib gsl libpng libX11 xproto libXext xextproto 
    libXt zlib gettext intltool perl
  ];
in
rec {
  src = fetchurl {
    url = "mirror://sourceforge/xaos/xaos-${version}.tar.gz";
    sha256 = "0hj8sxya4s9rc1m4xvxj00jgiczi3ljf2zvrhx34r3ja2m9af7s7";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["preConfigure" "doConfigure" "doMakeInstall"];

  preConfigure = a.fullDepEntry (''
    sed -e s@/usr/@"$out/"@g -i configure $(find . -name 'Makefile*')
    mkdir -p $out/share/locale
  '') ["doUnpack" "minInit" "defEnsureDir"];
      
  name = "xaos-" + version;
  meta = {
    homepage = http://xaos.sourceforge.net/;
    description = "XaoS - fractal viewer";
    license = "GPLv2+";
  };
}
