{
  fetchzip,
  lib,
  stdenv,
  makeWrapper,
  openjdk,
}:

stdenv.mkDerivation rec {
  pname = "gremlin-console";
  version = "3.7.3";
  src = fetchzip {
    url = "https://downloads.apache.org/tinkerpop/${version}/apache-tinkerpop-gremlin-console-${version}-bin.zip";
    sha256 = "sha256-27S1ukq9rHncFuPBZmwIP/bKuPYm3AxdBK3PliYTGEQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/opt
    cp -r ext lib $out/opt/
    install -D bin/gremlin.sh $out/opt/bin/gremlin-console
    makeWrapper $out/opt/bin/gremlin-console $out/bin/gremlin-console \
      --prefix PATH ":" "${openjdk}/bin/" \
      --set CLASSPATH "$out/opt/lib/"
    runHook postInstall
  '';

  meta = {
    homepage = "https://tinkerpop.apache.org/";
    description = "Console of the Apache TinkerPop graph computing framework";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.lewo ];
    platforms = lib.platforms.all;
    mainProgram = "gremlin-console";
  };
}
