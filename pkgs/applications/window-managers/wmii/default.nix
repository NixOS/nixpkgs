args: with args; stdenv.mkDerivation {
  name = "wmii-20070516";

  src = fetchurl {
    url = http://www.suckless.org/snaps/wmii-snap20070304.tgz;
    sha256 = "01ba1qk48n6wgpnavdwakgwmv895jvqvi75sm2wsvd6bqmc2xp86";
  };

  buildInputs = [ libX11 libixp ];
  inherit libixp;

  phases = "unpackPhase installPhase";

  installPhase = "
     export CFLAGS=\$NIX_CFLAGS_COMPILE
     export LDFLAGS\=$(echo \$NIX_LDFLAGS | sed -e 's/-rpath/-L/g')
     sed -i -e \"s%^PREFIX.*%PREFIX=\$out%\" \\
            -e \"s%^\\(INCS.*\\)%\\1 \$NIX_CFLAGS_COMPILE%\" \\
            -e \"s%^\\(LIBS.*\\)%\\1 \$LDFLAGS%\" \\
	    -e 's%^\\(AWKPATH = \\).*%\\1${gawk}/bin/gawk%' \\
            config.mk
     # don't use the default one installed by nixos!
     sed -i -e \"s%ixpc%\$libixp/bin/ixpc%\" wmiir
     make install
  ";
  meta = { homepage = "www.suckless.org";
           description = "a really cool window manager which can by driven by keyboard only";
           license="MIT";
         };
}
