{ lib, stdenv, fetchurl, jre, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "alchemy";
  version = "008";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "http://al.chemy.org/files/Alchemy-${version}.tar.gz";
    sha256 = "0449bvdccgx1jqnws1bckzs4nv2d230523qs0jx015gi81s1q7li";
  };

  installPhase = ''
    mkdir -p $out/bin $out/share
    cp -a . $out/share/alchemy
    cat >> $out/bin/alchemy << EOF
    #!${runtimeShell}
    cd $out/share/alchemy
    ${jre}/bin/java -jar Alchemy.jar "$@"
    EOF
    chmod +x $out/bin/alchemy
  '';

  meta = with lib; {
    description = "Drawing application";
    longDescription = ''
      Alchemy is an open drawing project aimed at exploring how we can sketch,
      draw, and create on computers in new ways. Alchemy isn’t software for
      creating finished artwork, but rather a sketching environment that
      focuses on the absolute initial stage of the creation process.
      Experimental in nature, Alchemy lets you brainstorm visually to explore
      an expanded range of ideas and possibilities in a serendipitous way.
    '';
    homepage = "http://al.chemy.org/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.linux;
    mainProgram = "alchemy";
  };
}
