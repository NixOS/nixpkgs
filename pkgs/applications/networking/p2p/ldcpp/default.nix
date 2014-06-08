{ builderDefs, scons, pkgconfig, gtk, bzip2, libglade, openssl, libX11, boost, zlib }:

with builderDefs;
  let localDefs = builderDefs.passthru.function ((rec {
    src = /* put a fetchurl here */
    fetchurl {
      url = http://launchpad.net/linuxdcpp/1.1/1.1.0/+download/linuxdcpp-1.1.0.tar.bz2;
      sha256 = "66012740e9347a2e994c8af5609c40ebf3f86f767258e071a03ef39a2314298a";
    };

    buildInputs = [scons pkgconfig gtk bzip2 libglade
      openssl libX11 boost];
    configureFlags = [];
    doScons = fullDepEntry (''
      mkdir -p $out
      export NIX_LDFLAGS="$NIX_LDFLAGS -lX11";
      
      for i in gettext xgettext msgfmt msgcat; do
        echo > $i
	chmod a+x $i
      done
      export PATH=$PATH:$PWD

      scons PREFIX=$out 
      scons PREFIX=$out install
    '') ["minInit" "doUnpack" "addInputs" "defEnsureDir"];
  }));
  in with localDefs;
stdenv.mkDerivation rec {
  name = "ldcpp-1.1.0";
  builder = writeScript (name + "-builder")
    (textClosure localDefs 
      [doScons doForceShare doPropagate]);
  meta = {
    description = "Linux DC++ - Direct Connect client";
  };
}
