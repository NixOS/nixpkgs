{ lib, stdenv, fetchzip, jdk17, testers, wrapGAppsHook3, igv }:

stdenv.mkDerivation rec {
  pname = "igv";
  version = "2.17.4";
  src = fetchzip {
    url = "https://data.broadinstitute.org/igv/projects/downloads/${lib.versions.majorMinor version}/IGV_${version}.zip";
    sha256 = "sha256-LF/rwm/XlLHAJjiAlQVTmx5l+5Np2b5rPjoCdN/qERU=";
  };

  installPhase = ''
    mkdir -pv $out/{share,bin}
    cp -Rv * $out/share/

    sed -i "s#prefix=.*#prefix=$out/share#g" $out/share/igv.sh
    sed -i 's#\bjava\b#${jdk17}/bin/java#g' $out/share/igv.sh

    sed -i "s#prefix=.*#prefix=$out/share#g" $out/share/igvtools
    sed -i 's#\bjava\b#${jdk17}/bin/java#g' $out/share/igvtools

    ln -s $out/share/igv.sh $out/bin/igv
    ln -s $out/share/igvtools $out/bin/igvtools

    chmod +x $out/bin/igv
    chmod +x $out/bin/igvtools
  '';
  nativeBuildInputs = [ wrapGAppsHook3 ];

  passthru.tests.version = testers.testVersion {
    package = igv;
  };


  meta = with lib; {
    homepage = "https://www.broadinstitute.org/igv/";
    description = "Visualization tool for interactive exploration of genomic datasets";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimame ];
  };
}
