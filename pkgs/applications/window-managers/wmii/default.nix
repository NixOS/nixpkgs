args: with args; stdenv.mkDerivation {
  name = "wmii-20071116";

  src = fetchurl {
    url = http://dl.suckless.org/wmii/wmii-3.6.tar.gz;
    sha256 = "46f39b788c5ef4695040b36cc7d9c539db0306bafc4d8cefdc5980ed4331b216";
  };

  buildInputs = [ libX11 libixp xextproto libXt libXext ];
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
