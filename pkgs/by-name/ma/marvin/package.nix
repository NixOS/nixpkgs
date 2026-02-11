{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  coreutils,
  gawk,
  gnugrep,
  gnused,
  openjdk17,
  freetype,
  fontconfig,
  libxi,
  libx11,
  libxext,
  libxtst,
  libxrender,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "marvin";
  version = "25.3.5";

  src = fetchurl {
    name = "marvin-${finalAttrs.version}.deb";
    url = "http://dl.chemaxon.com/marvin/${finalAttrs.version}/marvin_linux_${finalAttrs.version}.deb";
    hash = "sha256-OiTHMGKAuHadoKQMTTPRcYl/zKL+bc0ts/UNsJlHn0Q=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  buildInputs = [
    freetype
    fontconfig
    libxi
    libx11
    libxext
    libxtst
    libxrender
  ];

  unpackPhase = ''
    dpkg-deb -x $src opt
  '';

  installPhase = ''
    wrapBin() {
      makeWrapper $1 $out/bin/$(basename $1) \
        --set INSTALL4J_JAVA_HOME "${openjdk17}" \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs} \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            gawk
            gnugrep
            gnused
          ]
        }
    }
    cp -r opt $out
    mkdir -p $out/bin $out/share/pixmaps $out/share/applications
    for name in LicenseManager MarvinSketch MarvinView; do
      wrapBin $out/opt/chemaxon/marvinsuite/$name
      ln -s {$out/opt/chemaxon/marvinsuite/.install4j,$out/share/pixmaps}/$name.png
    done
    for name in cxcalc cxtrain evaluate molconvert mview msketch; do
      wrapBin $out/opt/chemaxon/marvinsuite/bin/$name
    done
    ${lib.concatStrings (
      map
        (name: ''
          substitute ${./. + "/${name}.desktop"} $out/share/applications/${name}.desktop --subst-var out
        '')
        [
          "LicenseManager"
          "MarvinSketch"
          "MarvinView"
        ]
    )}
  '';

  meta = {
    description = "Chemical modelling, analysis and structure drawing program";
    homepage = "https://chemaxon.com/products/marvin";
    maintainers = with lib.maintainers; [ fusion809 ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
  };
})
