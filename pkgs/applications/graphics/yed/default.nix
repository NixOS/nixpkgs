{ stdenv, fetchurl, requireFile, makeWrapper, unzip, jre }:

stdenv.mkDerivation rec {
  name = "yEd-${version}";
  version = "3.17.2";

  src = requireFile {
    name = "${name}.zip";
    url = "https://www.yworks.com/en/products/yfiles/yed/";
    sha256 = "0wpfvd3jqxgjk3xqkamvlg7rk0w0pmrv7srjfqns447ccc3i7qg2";
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
