{ stdenv, fetchurl, jdk }:

stdenv.mkDerivation rec {
  pname = "emem";
  version = "0.2.42";
  name = "${pname}-${version}";

  inherit jdk;

  src = fetchurl {
    url = "https://github.com/ebzzry/${pname}/releases/download/v${version}/${pname}.jar";
    sha256 = "0zm3sqgbiaj44nkgkjiifxwwyrcjs42nry6zmbg3dnnpd0v82v8j";
  };

  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    mkdir -p $out/bin $out/share/java
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
