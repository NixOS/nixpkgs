{
  stdenv,
  lib,
  makeWrapper,
  fetchzip,
  jre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bftools";
  version = "7.3.0";

  src = fetchzip {
    url = "http://downloads.openmicroscopy.org/bio-formats/${finalAttrs.version}/artifacts/bftools.zip";
    hash = "sha256-EQ7P07d53e6Q/9Wt2Pa1h0TfuYblOZeByGW30oE3i6M=";
  };

  installPhase = ''
    find . -maxdepth 1 -perm -111 -type f -not -name "*.sh" \
      -exec install -vD {} "$out"/bin/{} \;

    mkdir $out/libexec
    mkdir -p $out/share/java

    cp ./*.sh $out/libexec
    cp ./*.jar $out/share/java

    for file in $out/bin/*; do
      substituteInPlace $file --replace "\$BF_DIR" $out/libexec
    done
    substituteInPlace $out/libexec/bf.sh --replace "\$BF_JAR_DIR" $out/share/java
  '';

  postFixup = ''
    wrapProgram $out/libexec/bf.sh --prefix PATH : "${lib.makeBinPath [ jre ]}"
  '';

  nativeBuildInputs = [ makeWrapper ];

  meta = {
    description = "Bundle of scripts for using Bio-Formats on the command line with bioformats_package.jar already included";
    mainProgram = "showinf";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    homepage = "https://www.openmicroscopy.org/bio-formats/";
    maintainers = [ lib.maintainers.tbenst ];
  };
})
