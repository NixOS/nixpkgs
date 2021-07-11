{ lib, stdenv, fetchsvn, jdk, jre, ant, swt, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "BiglyBT";
  version = "v2.8.0.0";

  src = fetchFromGitHub {
    owner = "BiglySoftware";
    repo = "BiglyBT";
    rev = "4e1fff3f0dbe5a1065ac4661f865b01232357db6"; 
    sha256 = "c05b488fcc48e98a568813f82a39b1a596efababadc77ca443e7f7a1007252f5";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk ant ];

  buildPhase = "ant";

  installPhase = ''
    install -D dist/BiglyBT_0000-00.jar $out/share/java/BiglyBT_${version}-00.jar
    makeWrapper ${jre}/bin/java $out/bin/biglybt \
      --add-flags "-Xmx256m -Djava.library.path=${swt}/lib -cp $out/share/java/BiglyBT_${version}-00.jar:${swt}/jars/swt.jar org.gudy.azureus2.ui.swt.Main"
  '';

  meta = with lib; {
    description = "Torrent client";
    homepage = "http://www.biglybt.com";
    license = licenses.unfree;
    platforms = platforms.all;
    maintainers = with maintainers; [ joaquinito2051 ];
  };
}
