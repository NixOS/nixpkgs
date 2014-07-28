a :
let
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "3.6" a;
  buildInputs = with a; [
    aalib gsl libpng libX11 xproto libXext xextproto
    libXt zlib gettext intltool perl
  ];
in
rec {
  src = fetchurl {
    url = "mirror://sourceforge/xaos/xaos-${version}.tar.gz";
    sha256 = "15cd1cx1dyygw6g2nhjqq3bsfdj8sj8m4va9n75i0f3ryww3x7wq";
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
    license = a.stdenv.lib.licenses.gpl2Plus;
  };
}
