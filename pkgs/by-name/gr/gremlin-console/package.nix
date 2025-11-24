{
  fetchzip,
  lib,
  stdenv,
  makeWrapper,
  openjdk11,
}:
let
  openjdk = openjdk11;
in
stdenv.mkDerivation rec {
  pname = "gremlin-console";
  version = "3.8.0";
  src = fetchzip {
    url = "https://downloads.apache.org/tinkerpop/${version}/apache-tinkerpop-gremlin-console-${version}-bin.zip";
    sha256 = "sha256-vTv2a3+Ezd87ph4BnRaypPuUz0/s8DFcHVsKaURucTY=";
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

  meta = with lib; {
    homepage = "https://tinkerpop.apache.org/";
    description = "Console of the Apache TinkerPop graph computing framework";
    license = licenses.asl20;
    maintainers = [ maintainers.lewo ];
    platforms = platforms.all;
    mainProgram = "gremlin-console";
  };
}
