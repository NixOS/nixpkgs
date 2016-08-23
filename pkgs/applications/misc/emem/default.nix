{ stdenv, fetchurl, jdk }:

stdenv.mkDerivation rec {
  pname = "emem";
  version = "0.2.26";
  name = "${pname}-${version}";

  inherit jdk;

  src = fetchurl {
    url = "https://github.com/ebzzry/${pname}/releases/download/v${version}/${pname}.jar";
    sha256 = "1qa3q2zgy20yq060b8gz5h7f5h8kbbk7rgfxvjbxllgd847qs4dy";
  };

  buildInputs = [ ];

  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/java
  '';

  installPhase = ''
    cp $src $out/share/java/${pname}.jar

    cat > $out/bin/${pname} <<EOF
#! $SHELL
$jdk/bin/java -jar $out/share/java/${pname}.jar "\$@"
EOF

    chmod +x $out/bin/${pname}
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/ebzzry/emem;
    description = "A trivial Markdown to HTML converter";
    license = licenses.epl10;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.unix;
  };
}
