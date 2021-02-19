{ lib, stdenv, fetchurl, unzip, jdk, makeWrapper}:

stdenv.mkDerivation {
  version = "4.3.0";
  pname = "omegat";

  src = fetchurl {  # their zip has repeated files or something, so no fetchzip
    url = "mirror://sourceforge/project/omegat/OmegaT%20-%20Standard/OmegaT%204.3.0/OmegaT_4.3.0_Without_JRE.zip";
    sha256 = "0axz7r30p34z5hgvdglznc82g7yvm3g56dv5190jixskx6ba58rs";
  };

  nativeBuildInputs = [ makeWrapper unzip ];

  unpackCmd = "unzip -o $curSrc";  # tries to go interactive without -o

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
    description = "The free computer aided translation (CAT) tool for professionals";
    longDescription = ''
      OmegaT is a free and open source multiplatform Computer Assisted Translation
      tool with fuzzy matching, translation memory, keyword search, glossaries, and
      translation leveraging into updated projects.
    '';
    homepage = "http://www.omegat.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ t184256 ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
