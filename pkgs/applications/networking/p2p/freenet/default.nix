{ stdenv, fetchurl, ant, jdk }:

let
  # The .gitmodules in freenet-official-20130413-eccc9b3198
  # points to freenet-contrib-staging-ce3b7d5
  freenet_ext = fetchurl {
    url = https://downloads.freenetproject.org/latest/freenet-ext.jar;
    sha1 = "507ab3f6ee91f47c187149136fb6d6e98f9a8c7f";
  };

  bcprov = fetchurl {
    url = http://www.bouncycastle.org/download/bcprov-jdk15on-148.jar;
    sha256 = "12129q8rmqwlvj6z4j0gc3w0hq5ccrkf2gdlsggp3iws7cp7wjw0";
  };
in
stdenv.mkDerivation {
  name = "freenet-20130413-eccc9b3198";

  src = fetchurl {
    url = https://github.com/freenet/fred-official/tarball/eccc9b3198;
    name = "freenet-official-eccc9b3198.tar.gz";
    sha256 = "0x0s8gmb95770l7968r99sq0588vf0n1687ivc2hixar19cw620y";
  };

  patchPhase = ''
    cp ${freenet_ext} lib/freenet/freenet-ext.jar
    cp ${bcprov} lib/bcprov.jar

    sed '/antcall.*-ext/d' -i build.xml
  '';

  buildInputs = [ ant jdk ];

  buildPhase = "ant package-only";

  installPhase = ''
    mkdir -p $out/share/freenet $out/bin
    cp lib/bcprov.jar $out/share/freenet
    cp lib/freenet/freenet-ext.jar $out/share/freenet
    cp dist/freenet.jar $out/share/freenet

    cat <<EOF > $out/bin/freenet
    #!${stdenv.shell}
    ${jdk.jre}/bin/java -cp $out/share/freenet/bcprov.jar:$out/share/freenet/freenet-ext.jar:$out/share/freenet/freenet.jar \\
      -Xmx1024M freenet.node.NodeStarter
    EOF
    chmod +x $out/bin/freenet
  '';

  meta = {
    description = "Decentralised and censorship-resistant network";
    homepage = https://freenetproject.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = with stdenv.lib.platforms; linux;
  };
}
