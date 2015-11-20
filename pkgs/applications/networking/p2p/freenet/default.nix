{ stdenv, fetchurl, fetchgit, ant, jdk, makeWrapper }:

let
  freenet_ext = fetchurl {
    url = https://downloads.freenetproject.org/latest/freenet-ext.jar;
    sha256 = "17ypljdvazgx2z6hhswny1lxfrknysz3x6igx8vl3xgdpvbb7wij";
  };

  bcprov = fetchurl {
    url = https://downloads.freenetproject.org/latest/bcprov-jdk15on-152.jar;
    sha256 = "0wqpdcvcfh939fk8yr033ijzr1vjbp6ydlnv5ly8jiykwj0x3i0d";
  };
  seednodes = fetchurl {
    url = https://downloads.freenetproject.org/alpha/opennet/seednodes.fref;
    sha256 = "109zn9w8axdkjwhkkcm2s8dvib0mq0n8imjgs3r8hvi128cjsmg9";
  };
  version = "build01470";
in
stdenv.mkDerivation {
  name = "freenet-${version}";


  src = fetchgit {
    url = https://github.com/freenet/fred;
    rev = "refs/tags/${version}";
    sha256 = "1b6e6fec2b9a729d4a25605fa142df9ea42e59b379ff665f580e32c6178c9746";
  };

  patchPhase = ''
    cp ${freenet_ext} lib/freenet/freenet-ext.jar
    cp ${bcprov} lib/bcprov-jdk15on-152.jar

    sed '/antcall.*-ext/d' -i build.xml
    sed 's/@unknown@/${version}/g' -i build-clean.xml
  '';

  buildInputs = [ ant jdk makeWrapper ];

  buildPhase = "ant package-only";

  freenetWrapper = ./freenetWrapper;

  installPhase = ''
    mkdir -p $out/share/freenet $out/bin
    cp lib/bcprov-jdk15on-152.jar $out/share/freenet
    cp lib/freenet/freenet-ext.jar $out/share/freenet
    cp dist/freenet.jar $out/share/freenet

    cat <<EOF > $out/bin/freenet.wrapped
    #!${stdenv.shell}
    ${jdk.jre}/bin/java -cp $out/share/freenet/bcprov-jdk15on-152.jar:$out/share/freenet/freenet-ext.jar:$out/share/freenet/freenet.jar \\
      -Xmx1024M freenet.node.NodeStarter
    EOF
    chmod +x $out/bin/freenet.wrapped
    makeWrapper $freenetWrapper $out/bin/freenet \
      --set FREENET_ROOT "$out" \
      --set FREENET_SEEDNODES "${seednodes}"
  '';

  meta = {
    description = "Decentralised and censorship-resistant network";
    homepage = https://freenetproject.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.doublec ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
