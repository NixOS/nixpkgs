{ stdenv, fetchurl, requireFile, makeWrapper, unzip, jre }:

stdenv.mkDerivation rec {
  name = "yEd-3.14.4";

  src = requireFile {
    name = "${name}.zip";
    url = "https://www.yworks.com/en/products/yfiles/yed/";
    sha256 = "0pm271ss6cq2s6cv9ww92haaq2abkjxd9dvc8d72h6af5awv8xy6";
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
    license = licenses.unfree;
    homepage = http://www.yworks.com/en/products/yfiles/yed/;
    description = "A powerful desktop application that can be used to quickly and effectively generate high-quality diagrams";
    platforms = jre.meta.platforms;
    maintainers = with maintainers; [ abbradar ];
  };
}
