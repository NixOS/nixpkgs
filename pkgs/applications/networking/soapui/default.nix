{ fetchurl, stdenv, writeText, jdk, maven, makeWrapper }:

stdenv.mkDerivation rec {
  name = "soapui-${version}";
  version = "5.5.0";

  src = fetchurl {
    url = "https://s3.amazonaws.com/downloads.eviware/soapuios/${version}/SoapUI-${version}-linux-bin.tar.gz";
    sha256 = "0v1wiy61jgvlxjk8qdvcnyn1gh2ysxf266zln7r4wpzwd5gc3dpw";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk maven ];

  installPhase = ''
    mkdir -p $out/share/java
    cp -R bin lib $out/share/java

    makeWrapper $out/share/java/bin/soapui.sh $out/bin/soapui --set SOAPUI_HOME $out/share/java
  '';

  patches = [
    (writeText "soapui-${version}.patch" ''
      --- a/bin/soapui.sh
      +++ b/bin/soapui.sh
      @@ -34,7 +34,7 @@ SOAPUI_CLASSPATH=$SOAPUI_HOME/bin/soapui-${version}.jar:$SOAPUI_HOME/lib/*
       export SOAPUI_CLASSPATH

       JAVA_OPTS="-Xms128m -Xmx1024m -XX:MinHeapFreeRatio=20 -XX:MaxHeapFreeRatio=40 -Dsoapui.properties=soapui.properties -Dsoapui.home=$SOAPUI_HOME/bin -splash:SoapUI-Spashscreen.png"
      -JFXRTPATH=`java -cp $SOAPUI_CLASSPATH com.eviware.soapui.tools.JfxrtLocator`
      +JFXRTPATH=`${jdk}/bin/java -cp $SOAPUI_CLASSPATH com.eviware.soapui.tools.JfxrtLocator`
       SOAPUI_CLASSPATH=$JFXRTPATH:$SOAPUI_CLASSPATH

       if $darwin
      @@ -69,4 +69,4 @@ echo = SOAPUI_HOME = $SOAPUI_HOME
       echo =
       echo ================================

      -java $JAVA_OPTS -cp $SOAPUI_CLASSPATH com.eviware.soapui.SoapUI "$@"
      +${jdk}/bin/java $JAVA_OPTS -cp $SOAPUI_CLASSPATH com.eviware.soapui.SoapUI "$@"
    '')
  ];

  meta = with stdenv.lib; {
    description = "The Most Advanced REST & SOAP Testing Tool in the World";
    homepage = https://www.soapui.org/;
    license = "SoapUI End User License Agreement";
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.all;
  };
}
