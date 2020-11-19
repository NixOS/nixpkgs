{ stdenv, fetchzip, jdk11 }:

stdenv.mkDerivation rec {
  pname = "igv";
  version = "2.8.12";
  src = fetchzip {
    url = "https://data.broadinstitute.org/igv/projects/downloads/2.8/IGV_${version}.zip";
    sha256 = "0zxmk417j9s5nms0np1fsip7r0jhwkj1d1x424ljr9krcb2zwcyq";
  };

  installPhase = ''
    mkdir -pv $out/{share,bin}
    cp -Rv * $out/share/

    sed -i "s#prefix=.*#prefix=$out/share#g" $out/share/igv.sh
    sed -i 's#java#${jdk11}/bin/java#g' $out/share/igv.sh

    sed -i "s#prefix=.*#prefix=$out/share#g" $out/share/igvtools
    sed -i 's#java#${jdk11}/bin/java#g' $out/share/igvtools

    ln -s $out/share/igv.sh $out/bin/igv
    ln -s $out/share/igvtools $out/bin/igvtools

    chmod +x $out/bin/igv
    chmod +x $out/bin/igvtools
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.broadinstitute.org/igv/";
    description = "A visualization tool for interactive exploration of genomic datasets";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimame ];
  };
}
