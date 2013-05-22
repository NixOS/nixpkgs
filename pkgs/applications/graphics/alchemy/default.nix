{stdenv, fetchurl, jre}:

stdenv.mkDerivation {
  name = "alchemy-007-alpha";
  enableParallelBuilding = true;

  src = fetchurl {
    url = http://al.chemy.org/files/Alchemy-007.tar.gz;
    sha256 = "1pk00m4iajvv9jzv96in10czpcf7zc3d4nmd9biqagpsg28mr70b";
  };

  installPhase = ''
    ensureDir $out/bin $out/share
    cp -a . $out/share/alchemy
    cat >> $out/bin/alchemy << EOF
    #!/bin/sh
    cd $out/share/alchemy
    ${jre}/bin/java -jar Alchemy.jar "$@"
    EOF
    chmod +x $out/bin/alchemy
  '';

  meta = {
    description = "Drawing application";
    homepage = http://al.chemy.org/;
    license = stdenv.lib.licenses.gpl;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
