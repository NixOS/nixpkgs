{
  lib,
  stdenv,
  fetchzip,
  jdk21,
  testers,
  wrapGAppsHook3,
  igv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "igv";
  version = "2.19.8";
  src = fetchzip {
    url = "https://data.broadinstitute.org/igv/projects/downloads/${lib.versions.majorMinor finalAttrs.version}/IGV_${finalAttrs.version}.zip";
    sha256 = "sha256-WVf/y0+Hk3OIz+hlCTJ81Ui/s6vthFLJWLuBJAOGzaQ=";
  };

  installPhase = ''
    mkdir -pv $out/{share,bin}
    cp -Rv * $out/share/

    sed -i "s#prefix=.*#prefix=$out/share#g" $out/share/igv.sh
    sed -i 's#\bjava\b#${jdk21}/bin/java#g' $out/share/igv.sh

    sed -i "s#prefix=.*#prefix=$out/share#g" $out/share/igvtools
    sed -i 's#\bjava\b#${jdk21}/bin/java#g' $out/share/igvtools

    ln -s $out/share/igv.sh $out/bin/igv
    ln -s $out/share/igvtools $out/bin/igvtools

    chmod +x $out/bin/igv
    chmod +x $out/bin/igvtools
  '';
  nativeBuildInputs = [ wrapGAppsHook3 ];

  passthru.tests.version = testers.testVersion {
    package = igv;
  };

  meta = {
    homepage = "https://www.broadinstitute.org/igv/";
    description = "Visualization tool for interactive exploration of genomic datasets";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [
      lib.maintainers.mimame
      lib.maintainers.rollf
    ];
  };
})
