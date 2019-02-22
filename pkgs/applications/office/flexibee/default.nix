{ stdenv, fetchurl, jre, makeWrapper }:

let basever = "2019.1";
    version = "${basever}.0.1";in

stdenv.mkDerivation {
  name = "flexibee-${version}";

  src = fetchurl {
    url = "http://download.flexibee.eu/download/${basever}/${version}/flexibee-${version}.tar.gz";
    sha256 = "9e73b8c670c8e3f9548a7fe7fc7fbb9f4a0205c59564d4de01fd4bf18ef4ed38";
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
