{
  lib,
  stdenv,
  fetchzip,
  jre_minimal,
  makeWrapper,
  nixosTests,
}:
let
  jre = jre_minimal.override {
    modules = [
      "java.base"
      "java.datatransfer"
      "java.desktop"
      "java.naming"
      "java.sql"
      "java.xml"
      "jdk.httpserver"
    ];
  };
in
stdenv.mkDerivation rec {
  pname = "languagetool";
  version = "6.6";

  src = fetchzip {
    url = "https://www.languagetool.org/download/LanguageTool-${version}.zip";
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

  passthru = {
    inherit jre;
    tests.languagetool = nixosTests.languagetool;
  };

  meta = {
    homepage = "https://languagetool.org";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ edwtjo ];
    platforms = jre.meta.platforms;
    description = "Proofreading program for English, French German, Polish, and more";
    mainProgram = "languagetool";
  };
}
