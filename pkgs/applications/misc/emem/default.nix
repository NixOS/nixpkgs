{ lib, stdenv, fetchurl, jdk }:

stdenv.mkDerivation rec {
  pname = "emem";
  version = "0.2.50";

  inherit jdk;

  src = fetchurl {
    url = "https://github.com/ebzzry/${pname}/releases/download/v${version}/${pname}.jar";
    sha256 = "18x3s3jrph8k3pc75jgwkfqazygpsx93zjxx68zms58my17cybh1";
  };

  dontUnpack = true;

  buildPhase = ''
    mkdir -p $out/bin $out/share/java
  '';

  installPhase = ''
    cp $src $out/share/java/${pname}.jar

    cat > $out/bin/${pname} << EOF
#! $SHELL
$jdk/bin/java -jar $out/share/java/${pname}.jar "\$@"
EOF

    chmod +x $out/bin/${pname}
  '';

  meta = with lib; {
    homepage = "https://github.com/ebzzry/emem";
    description = "Trivial Markdown to HTML converter";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.epl10;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.unix;
    mainProgram = "emem";
  };
}
