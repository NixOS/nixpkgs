args: with args; stdenv.mkDerivation {
  name = "wmii-3.9b1";

  src = fetchurl {
    url = http://dl.suckless.org/wmii/wmii+ixp-3.9b1.tbz;
    name = "wmii+ixp-3.9b1.tar.bz2"; # srcUnpack does not know about tbz
    sha256 = "0i04mf5cl4m6mn5kcy913mmrnd2ir0ardmskswchnr6fxpbcyvml";
  };

  buildInputs = [ libX11 libixp xextproto libXt libXext libXft
    freetype libXrandr libXinerama pkgconfig];
  inherit libixp;

  phases = "unpackPhase installPhase";

  installPhase = "
     for i in libfmt libutf libregexp libbio; do
       cd $i; make; cd ..
     done
     mkdir -p \$out/lib
     cp ${libixp}/lib/libixp.a \$out/lib
     export CFLAGS=\$NIX_CFLAGS_COMPILE
     export LDFLAGS\=$(echo \$NIX_LDFLAGS | sed -e 's/-rpath/-L/g')
     sed -i -e \"s%^PREFIX.*%PREFIX=\$out%\" \\
            -e \"s%^\\(INCS.*\\)%\\1 \$NIX_CFLAGS_COMPILE%\" \\
            -e \"s%^\\(LIBS.*\\)%\\1 \$LDFLAGS%\" \\
            -e 's%^\\(AWKPATH = \\).*%\\1${gawk}/bin/gawk%' \\
            config.mk
     # don't use the default one installed by nixos!
     #sed -i -e \"s%ixpc%\$libixp/bin/ixpc%\" wmiir
     make install
  ";
  meta = { homepage = "www.suckless.org";
           description = "a really cool window manager which can by driven by keyboard only";
           license="MIT";
         };
}
