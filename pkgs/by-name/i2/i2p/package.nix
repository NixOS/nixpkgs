{
  lib,
  stdenv,
  fetchzip,
  jdk,
  ant,
  gettext,
  which,
  dbip-country-lite,
  java-service-wrapper,
  makeWrapper,
  gmp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "i2p";
  version = "2.10.0";

  src = fetchzip {
    urls = [
      "https://github.com/i2p/i2p.i2p/archive/i2p-${finalAttrs.version}.tar.gz"
    ]
    ++ (map (mirror: "${mirror}${finalAttrs.version}/i2psource_${finalAttrs.version}.tar.bz2") [
      "https://download.i2p2.de/releases/"
      "https://files.i2p-projekt.de/"
      "https://download.i2p2.no/releases/"
    ]);
    hash = "sha256-Ogok7s5sawG27ucstG+NYiIAF66Pb3ExOYsL8mfNav8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    ant
    gettext
    jdk
    which
  ];

  buildInputs = [ gmp ];

  postConfigure = ''
    rm -r installer/lib
    mkdir -p installer/lib/wrapper/all/
    # The java-service-wrapper is needed for build but not really used in runtime
    ln -s ${java-service-wrapper}/lib/wrapper.jar installer/lib/wrapper/all/wrapper.jar
    # Don't use the bundled geoip data
    echo "with-geoip-database=true" >> override.properties
  '';

  buildPhase = ''
    # When this variable exists we can build the .so files only.
    export DEBIANVERSION=1
    pushd core/c/jcpuid
    ./build.sh
    popd
    pushd core/c/jbigi
    ./build_jbigi.sh dynamic
    popd
    export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8"
    SOURCE_DATE_EPOCH=0 ant preppkg-unix
  '';

  installPhase = ''
    mkdir -p $out/{bin,share,geoip}
    mv pkg-temp/* $out
    mv core/c/jbigi/*.so $out/lib
    mv $out/man $out/share/
    rm $out/{osid,postinstall.sh,INSTALL-headless.txt}

    for jar in $out/lib/*.jar; do
      if [ ! -z $CP ]; then
        CP=$CP:$jar;
      else
        CP=$jar
      fi
    done

    makeWrapper ${jdk}/bin/java $out/bin/i2prouter \
      --add-flags "-cp $CP -Djava.library.path=$out/lib/ -Di2p.dir.base=$out -DloggerFilenameOverride=logs/log-router-@.txt" \
      --add-flags "net.i2p.router.RouterLaunch"

    ln -s ${dbip-country-lite.mmdb} $out/geoip/GeoLite2-Country.mmdb
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    # Check if jbigi is used
    java -cp $out/lib/i2p.jar -Djava.library.path=$out/lib/ net.i2p.util.NativeBigInteger \
      | tee /dev/stderr | grep -Fw "Found native library" || exit 1

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Applications and router for I2P, anonymity over the Internet";
    homepage = "https://geti2p.net";
    changelog = "https://github.com/i2p/i2p.i2p/releases/tag/i2p-${finalAttrs.version}";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # source bundles dependencies as jars
    ];
    license = with licenses; [
      asl20
      boost
      bsd2
      bsd3
      cc-by-30
      cc0
      epl10
      gpl2
      gpl3
      lgpl21Only
      lgpl3Only
      mit
      publicDomain
    ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [ linsui ];
    mainProgram = "i2prouter-plain";
  };
})
