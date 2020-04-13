{ fetchzip, stdenv, makeWrapper, openjdk }:

stdenv.mkDerivation rec {
  pname = "gremlin-console";
  version = "3.3.4";
  src = fetchzip {
    url = "http://www-eu.apache.org/dist/tinkerpop/${version}/apache-tinkerpop-gremlin-console-${version}-bin.zip";
    sha256 = "14xr0yqklmm4jvj1hnkj89lj83zzs2l1375ni0jbf12gy31jlb2w";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/opt
    cp -r ext lib $out/opt/
    install -D bin/gremlin.sh $out/opt/bin/gremlin-console
    makeWrapper $out/opt/bin/gremlin-console $out/bin/gremlin-console \
      --prefix PATH ":" "${openjdk}/bin/" \
      --set CLASSPATH "$out/opt/lib/"
  '';

  meta = with stdenv.lib; {
    homepage = "https://tinkerpop.apache.org/";
    description = "Console of the Apache TinkerPop graph computing framework";
    license = licenses.asl20;
    maintainers = [ maintainers.lewo ];
    platforms = platforms.all;
  };
}
