{ stdenv, fetchurl, jdk }:

stdenv.mkDerivation rec {
  pname = "emem";
  version = "0.2.22";
  name = "${pname}-${version}";

  inherit jdk;

  src = fetchurl {
    url = "https://github.com/ebzzry/${pname}/releases/download/v${version}/${pname}.jar";
    sha256 = "0s7w34h18b076hhg327gvn9lrhmy2qknh7qzsywpv9l7j7l8jfv5";
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
