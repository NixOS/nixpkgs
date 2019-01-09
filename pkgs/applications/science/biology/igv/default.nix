{ stdenv, fetchurl, unzip, jre }:

stdenv.mkDerivation rec {
  name = "igv-${version}";
  version = "2.4.16";

  src = fetchurl {
    url = "https://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_${version}.zip";
    sha256 = "0bsl20zw7sgw16xadh1hmlg6d6ijyb1dhpnyvf4kxk3nk0abrmn1";
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
    homepage = https://www.broadinstitute.org/igv/;
    description = "A visualization tool for interactive exploration of genomic datasets";
    license = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimadrid ];
  };
}
