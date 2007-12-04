{stdenv, fetchurl, autoconf, automake, gettext, libtool, cvs, wxGTK, gtk,
pkgconfig, libxml2, zip, libpng, libjpeg, shebangfix, perl, freetype}:

stdenv.mkDerivation {
  name = "xaralx-0.7r1766";
  src = fetchurl {
    url = http://downloads2.xara.com/opensource/XaraLX-0.7r1766.tar.bz2;
    sha256 = "1rcl7hqvcai586jky7hvzxhnq8q0ka2rsmgiq5ijwclgr5d4ah7n";
  };
    
  buildInputs = [automake autoconf gettext libtool cvs wxGTK gtk pkgconfig libxml2 zip libpng libjpeg shebangfix perl];

  inherit freetype libpng libjpeg libxml2;
  configureFlags = "--with-wx-config --disable-svnversion --disable-international";

  patches = [./gtk_cflags.patch];

  # Why do I need to add library path for freetype ? 
  installPhase = "
    make install
    ensureDir \$out/lib
    mv \$out/{bin,lib}/XaraLX
cat >> \$out/bin/XaraLX << EOF
#!/bin/sh
LD_LIBRARY_PATH=\$freetype/lib:\$libpng/lib:\$libjpeg/lib:\$libxml2/lib:
\$out/lib/XaraLX \"\\$@\"
EOF
chmod +x \$out/bin/XaraLX
";
 
  patchPhase = "
    find . -iname \"*.pl\" | xargs shebangfix;
    unset patchPhase; patchPhase
   "; 
}
