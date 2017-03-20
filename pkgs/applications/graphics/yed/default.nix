{ stdenv, fetchurl, requireFile, makeWrapper, unzip, jre }:

stdenv.mkDerivation rec {
  name = "yEd-${version}";
  version = "3.17";

  src = requireFile {
    name = "${name}.zip";
    url = "https://www.yworks.com/en/products/yfiles/yed/";
    sha256 = "1wk58cql90y3i5l7jlxqfjjgf26i0zrv5cn0p9npgagaw6aiw2za";
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
    homepage = "http://www.yworks.com/en/products/yfiles/yed/";
    description = "A powerful desktop application that can be used to quickly and effectively generate high-quality diagrams";
    platforms = jre.meta.platforms;
    maintainers = with maintainers; [ abbradar ];
  };
}
