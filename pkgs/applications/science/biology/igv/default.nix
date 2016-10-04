{ stdenv, fetchurl, unzip, jre }:

stdenv.mkDerivation rec {
  name = "igv-${version}";
  version = "2.3.77";

  src = fetchurl {
    url = "http://data.broadinstitute.org/igv/projects/downloads/IGV_${version}.zip";
    sha256 = "9d8c622649f9f02026e92fa44006bb57e897baad4359c8708ca9cdbb71f94bb5";
  };

  buildInputs = [ unzip jre ];

  installPhase = ''
    mkdir -pv $out/{share,bin}
    cp -Rv * $out/share/

    sed -i "s#prefix=.*#prefix=$out/share#g" $out/share/igv.sh
    sed -i 's#java#${jre}/bin/java#g' $out/share/igv.sh

    ln -s $out/share/igv.sh $out/bin/igv

    chmod +x $out/bin/igv
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.broadinstitute.org/igv/";
    description = "A visualization tool for interactive exploration of genomic datasets";
    license = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimadrid ];
  };
}
