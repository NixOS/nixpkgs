{
  lib,
  stdenv,
  fetchzip,
  jre,
  makeWrapper,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "LanguageTool";
  version = "6.6";

  src = fetchzip {
    url = "https://www.languagetool.org/download/${pname}-${version}.zip";
    sha256 = "sha256-BNiUIk5h38oEM4IliHdy8rNmZY0frQ1RaFeJ7HI5nOI=";
  };
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    mv -- * $out/share/

    for lt in languagetool{,-commandline,-server};do
      makeWrapper ${jre}/bin/java $out/bin/$lt \
        --add-flags "-cp $out/share/ -jar $out/share/$lt.jar"
    done

    makeWrapper ${jre}/bin/java $out/bin/languagetool-http-server \
      --add-flags "-cp $out/share/languagetool-server.jar org.languagetool.server.HTTPServer"

    runHook postInstall
  '';

  passthru.tests.languagetool = nixosTests.languagetool;

  meta = with lib; {
    homepage = "https://languagetool.org";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.lgpl21Plus;
    platforms = jre.meta.platforms;
    description = "Proofreading program for English, French German, Polish, and more";
  };
}
