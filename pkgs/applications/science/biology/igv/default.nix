{ lib, stdenv, fetchzip, jdk17, testers, wrapGAppsHook, igv }:

stdenv.mkDerivation rec {
  pname = "igv";
  version = "2.17.3";
  src = fetchzip {
    url = "https://data.broadinstitute.org/igv/projects/downloads/${lib.versions.majorMinor version}/IGV_${version}.zip";
    sha256 = "sha256-SGqkWBv4nol0+lnGN7wBHJvndcIqZ5+Wt1wAcXA42cU=";
  };

  installPhase = ''
    mkdir -pv $out/{share,bin}
    cp -Rv * $out/share/

    sed -i "s#prefix=.*#prefix=$out/share#g" $out/share/igv.sh
    sed -i 's#java#${jdk17}/bin/java#g' $out/share/igv.sh

    sed -i "s#prefix=.*#prefix=$out/share#g" $out/share/igvtools
    sed -i 's#java#${jdk17}/bin/java#g' $out/share/igvtools

    ln -s $out/share/igv.sh $out/bin/igv
    ln -s $out/share/igvtools $out/bin/igvtools

    chmod +x $out/bin/igv
    chmod +x $out/bin/igvtools
  '';
  nativeBuildInputs = [ wrapGAppsHook ];

  passthru.tests.version = testers.testVersion {
    package = igv;
  };


  meta = with lib; {
    homepage = "https://www.broadinstitute.org/igv/";
    description = "A visualization tool for interactive exploration of genomic datasets";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimame ];
  };
}
