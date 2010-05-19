args: with args; stdenv.mkDerivation {
  name = "wmiimenu-3.1";

  src = fetchurl {
    url = http://dl.suckless.org/wmii/wmii-3.1.tar.gz;
    sha256 = "0sviwxbanpsfdm55zvx9hflncw35slkz41xr517y3yfgxx6qlhlk";
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
            config.mk
     # don't use the default one installed by nixos!
     # sed -i -e \"s%ixpc%\$libixp/bin/ixpc%\" wmiir

     # This will fail but wmiimenu has been built (hack!)
     set +e
     make &> /dev/null
     set -e
     ensureDir \$out/bin
     cp cmd/wmiimenu \$out/bin
  ";
  meta = { homepage = "www.suckless.org";
           description = "one small tool of the wmii window manger to let the user select an item from a list by filtering..";
           license="MIT";
         };
}
