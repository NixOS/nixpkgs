{
  lib,
  stdenv,
  fetchurl,
  unzip,
  jdk,
  makeWrapper,
}:

stdenv.mkDerivation {
  version = "6.0.1";
  pname = "omegat";

  src = fetchurl {
    # their zip has repeated files or something, so no fetchzip
    url = "mirror://sourceforge/project/omegat/OmegaT%20-%20Standard/OmegaT%206.0.1/OmegaT_6.0.1_Without_JRE.zip";
    sha256 = "sha256-Rj50bzT8k7+GWb0p/ma+zy+PzkF7tB6iV4F4UVAImJg=";
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

  meta = with lib; {
    description = "Free computer aided translation (CAT) tool for professionals";
    mainProgram = "omegat";
    longDescription = ''
      OmegaT is a free and open source multiplatform Computer Assisted Translation
      tool with fuzzy matching, translation memory, keyword search, glossaries, and
      translation leveraging into updated projects.
    '';
    homepage = "http://www.omegat.org/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ t184256 ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
