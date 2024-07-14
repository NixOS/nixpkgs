{ fetchzip, lib, stdenv, makeWrapper, openjdk }:
stdenv.mkDerivation rec {
  pname = "gremlin-server";
  version = "3.7.0";
  src = fetchzip {
    url = "https://downloads.apache.org/tinkerpop/${version}/apache-tinkerpop-gremlin-server-${version}-bin.zip";
    sha256 = "sha256-cS7R7Raz5tkrr5DNeW7jbEYDee2OgE4htTXJRnqXlqI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  # Note you'll want to prefix any commands with LOG_DIR, PID_DIR, and RUN_DIR
  # environment variables set to a writable director(y/ies).

  installPhase = ''
    runHook preInstall
    mkdir -p $out/opt
    cp -r conf ext lib scripts $out/opt/
    install -D bin/gremlin-server.sh $out/opt/bin/gremlin-server
    makeWrapper $out/opt/bin/gremlin-server $out/bin/gremlin-server \
      --prefix PATH ":" "${openjdk}/bin/" \
      --set CLASSPATH "$out/opt/lib/"
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://tinkerpop.apache.org/";
    description = "Server of the Apache TinkerPop graph computing framework";
    license = licenses.asl20;
    maintainers = [ maintainers.jrpotter ];
    platforms = platforms.all;
    mainProgram = "gremlin-server";
  };
}
