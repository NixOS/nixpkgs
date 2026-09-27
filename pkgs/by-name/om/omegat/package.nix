{
  lib,
  stdenv,
  fetchurl,
  unzip,
  jdk,
  makeWrapper,
}:

stdenv.mkDerivation {
  version = "6.1.1";
  pname = "omegat";

  src = fetchurl {
    # their zip has repeated files or something, so no fetchzip
    url = "mirror://sourceforge/project/omegat/OmegaT%20-%20Standard/OmegaT%206.1.1/OmegaT_6.1.1_Without_JRE.zip";
    sha256 = "sha256-apnR+GeHs+ySARtH2LvYR9hfRuznC0xqrWN8WOtq9uk=";
  };

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

  unpackCmd = "unzip -o $curSrc"; # tries to go interactive without -o

  installPhase = ''
    mkdir -p $out/bin
    cp -r lib docs images plugins scripts *.txt *.html OmegaT.jar $out/

    cat > $out/bin/omegat <<EOF
    #! $SHELL -e
    CLASSPATH="$out/lib"
    exec ${jdk}/bin/java -jar -Xmx1024M $out/OmegaT.jar "\$@"
    EOF
    chmod +x $out/bin/omegat
  '';

  meta = {
    description = "Free computer aided translation (CAT) tool for professionals";
    mainProgram = "omegat";
    longDescription = ''
      OmegaT is a free and open source multiplatform Computer Assisted Translation
      tool with fuzzy matching, translation memory, keyword search, glossaries, and
      translation leveraging into updated projects.
    '';
    homepage = "http://www.omegat.org/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ t184256 ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
