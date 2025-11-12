{
  fetchurl,
  lib,
  stdenv,
  jre,
  makeWrapper,
  coreutils,
}:

stdenv.mkDerivation rec {
  pname = "jmeter";
  version = "5.6.3";
  src = fetchurl {
    url = "mirror://apache/jmeter/binaries/apache-${pname}-${version}.tgz";
    sha256 = "sha256-9o78F/4GD2mMSKar4lmakzknSGvaKSTb4Ux0iVMY3d4=";
  };

  nativeBuildInputs = [
    makeWrapper
    jre
  ];

  installPhase = ''
    mkdir $out

    rm bin/*.bat bin/*.cmd

    cp -R * $out/

    substituteInPlace $out/bin/create-rmi-keystore.sh --replace \
      "keytool -genkey" \
      "${jre}/lib/openjdk/jre/bin/keytool -genkey"

    # Fix mirror-server.sh classpath: discover actual jar names at build time
    oro_jar=$(basename $(ls $out/lib/oro-*.jar))
    slf4j_api_jar=$(basename $(ls $out/lib/slf4j-api-*.jar))
    jcl_over_slf4j_jar=$(basename $(ls $out/lib/jcl-over-slf4j-*.jar))
    log4j_slf4j_impl_jar=$(basename $(ls $out/lib/log4j-slf4j-impl-*.jar))
    log4j_api_jar=$(basename $(ls $out/lib/log4j-api-*.jar))
    log4j_core_jar=$(basename $(ls $out/lib/log4j-core-*.jar))
    log4j_1_2_api_jar=$(basename $(ls $out/lib/log4j-1.2-api-*.jar))

    substituteInPlace $out/bin/mirror-server.sh \
      --replace "oro-2.0.8.jar" "$oro_jar" \
      --replace "slf4j-api-1.7.25.jar" "$slf4j_api_jar" \
      --replace "jcl-over-slf4j-1.7.25.jar" "$jcl_over_slf4j_jar" \
      --replace "log4j-slf4j-impl-2.11.0.jar" "$log4j_slf4j_impl_jar" \
      --replace "log4j-api-2.11.1.jar" "$log4j_api_jar" \
      --replace "log4j-core-2.11.1.jar" "$log4j_core_jar" \
      --replace "log4j-1.2-api-2.11.1.jar" "$log4j_1_2_api_jar"

    # Prefix some scripts with jmeter to avoid clobbering the namespace
    for i in heapdump.sh mirror-server mirror-server.sh shutdown.sh stoptest.sh create-rmi-keystore.sh; do
      mv $out/bin/$i $out/bin/jmeter-$i
      wrapProgram $out/bin/jmeter-$i \
        --prefix PATH : "${jre}/bin"
    done

    wrapProgram $out/bin/jmeter --set JAVA_HOME "${jre}"
    wrapProgram $out/bin/jmeter.sh --set JAVA_HOME "${jre}"
  '';

  doInstallCheck = true;

  nativeCheckInputs = [ coreutils ];

  installCheckPhase = ''
    # Test basic functionality
    $out/bin/jmeter --version 2>&1 | grep -q "${version}"
    $out/bin/jmeter-heapdump.sh > /dev/null
    $out/bin/jmeter-shutdown.sh > /dev/null
    $out/bin/jmeter-stoptest.sh > /dev/null
    timeout --kill=1s 1s $out/bin/jmeter-mirror-server.sh || test "$?" = "124"
  '';

  meta = with lib; {
    description = "100% pure Java desktop application designed to load test functional behavior and measure performance";
    longDescription = ''
      The Apache JMeter desktop application is open source software, a 100%
      pure Java application designed to load test functional behavior and
      measure performance. It was originally designed for testing Web
      Applications but has since expanded to other test functions.
    '';
    license = licenses.asl20;
    maintainers = [ ];
    priority = 1;
    platforms = platforms.unix;
  };
}
