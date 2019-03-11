{ stdenv, fetchurl, jre, makeWrapper }:

let basever = "2019.2";
    version = "${basever}.0.2";in

stdenv.mkDerivation {
  name = "flexibee-${version}";

  src = fetchurl {
    url = "http://download.flexibee.eu/download/${basever}/${version}/flexibee-${version}.tar.gz";
    sha256 = "13dxv2asmh52dcw704dsz0vgg8kfnzdb5gj0sicdyvjz1df193y1";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir $out
    mkdir $out/bin

    cp -R * $out/

    # Remove unused files
    rm  $out/usr/bin/winstrom
    rm -R $out/usr/sbin
    rm -R $out/etc

    makeWrapper $out/usr/bin/flexibee $out/bin/flexibee --set JAVA_HOME ${jre} --set FLEXIBEE_DIR "$out/usr/share/flexibee"
  '';

  meta = {
    description = "Accounting economic system for person and business.";
    homepage = https://flexibee.eu;
    maintainers = [ stdenv.lib.maintainers.petrkr ];
    license = stdenv.lib.licenses.unfree;
  };
}
