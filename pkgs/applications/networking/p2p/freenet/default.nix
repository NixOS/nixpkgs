{ stdenv, fetchurl, fetchgit, ant, jdk, bash, coreutils, substituteAll }:

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

  freenet-jars = stdenv.mkDerivation {
    name = "freenet-jars-${version}";

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

    buildInputs = [ ant jdk ];

    buildPhase = "ant package-only";

    installPhase = ''
      mkdir -p $out/share/freenet
      cp lib/bcprov-jdk15on-152.jar $out/share/freenet
      cp lib/freenet/freenet-ext.jar $out/share/freenet
      cp dist/freenet.jar $out/share/freenet
    '';
  };

in stdenv.mkDerivation {
  name = "freenet-${version}";
  inherit version;

  src = substituteAll {
    src = ./freenetWrapper;
    inherit bash coreutils seednodes;
    freenet = freenet-jars;
    jre = jdk.jre;
  };

  jars = freenet-jars;

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/freenet
    chmod +x $out/bin/freenet
    ln -s ${freenet-jars}/share $out/share
  '';

  meta = {
    description = "Decentralised and censorship-resistant network";
    homepage = https://freenetproject.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.doublec ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
