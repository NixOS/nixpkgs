{ stdenv, fetchurl, makeWrapper, unzip, jre }:

stdenv.mkDerivation rec {
  name = "yEd-3.13";

  src = fetchurl {
    url = "http://www.yworks.com/products/yed/demo/${name}.zip";
    sha256 = "1d5qs6q31k49y9gh054aafck548pv9f97b3il4iksnna1r59w5jy";
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  installPhase = ''
    mkdir -p $out/yed
    cp -r * $out/yed
    mkdir -p $out/bin

    makeWrapper ${jre}/bin/java $out/bin/yed \
      --add-flags "-jar $out/yed/yed.jar --"
  '';

  meta = with stdenv.lib; {
    license = licenses.unfreeRedistributable;
    homepage = http://www.yworks.com/en/products/yfiles/yed/;
    description = "A powerful desktop application that can be used to quickly and effectively generate high-quality diagrams";
    platforms = jre.meta.platforms;
    maintainers = with maintainers; [ abbradar ];
  };
}
