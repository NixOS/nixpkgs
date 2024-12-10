{
  lib,
  stdenv,
  fetchsvn,
  jdk,
  jre,
  ant,
  swt,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "vuze";
  version = "5750";

  src = fetchsvn {
    url = "http://svn.vuze.com/public/client/tags/RELEASE_${version}";
    sha256 = "07w6ipyiy8hi88d6yxbbf3vkv26mj7dcz9yr8141hb2ig03v0h0p";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    jdk
    ant
  ];

  buildPhase = "ant";

  installPhase = ''
    install -D dist/Vuze_0000-00.jar $out/share/java/Vuze_${version}-00.jar
    makeWrapper ${jre}/bin/java $out/bin/vuze \
      --add-flags "-Xmx256m -Djava.library.path=${swt}/lib -cp $out/share/java/Vuze_${version}-00.jar:${swt}/jars/swt.jar org.gudy.azureus2.ui.swt.Main"
  '';

  meta = with lib; {
    description = "Torrent client";
    homepage = "http://www.vuze.com";
    license = licenses.unfree;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
    knownVulnerabilities = [
      "CVE-2018-13417"
    ];
  };
}
