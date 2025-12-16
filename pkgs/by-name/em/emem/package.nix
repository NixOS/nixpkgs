{
  lib,
  stdenv,
  fetchurl,
  jdk,
}:

stdenv.mkDerivation rec {
  pname = "emem";
  version = "0.2.51";

  inherit jdk;

  src = fetchurl {
    url = "https://github.com/ebzzry/${pname}/releases/download/v${version}/${pname}.jar";
    sha256 = "sha256-5esdlQtA+Q+x4GDr1F1eedcuDkO1+EkTR/jLTC9P4c4=";
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

  meta = {
    homepage = "https://github.com/ebzzry/emem";
    description = "Trivial Markdown to HTML converter";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.epl10;
    maintainers = [ lib.maintainers.ebzzry ];
    platforms = lib.platforms.unix;
    mainProgram = "emem";
  };
}
