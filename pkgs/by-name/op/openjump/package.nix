{
  lib,
  stdenv,
  fetchurl,
  unzip,
  makeBinaryWrapper,
  coreutils,
  gawk,
  which,
  gnugrep,
  findutils,
  jre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openjump";
  version = "2.3.0";
  revision = "r5279%5Bd24616e%5D";

  src = fetchurl {
    url = "mirror://sourceforge/jump-pilot/OpenJUMP/${finalAttrs.version}/OpenJUMP-Portable-${finalAttrs.version}-${finalAttrs.revision}-PLUS.zip";
    hash = "sha256-IO44iGnFQt/ir1WlvBrEHjdC+0DZTfJIVAJgRcxrFMI=";
  };

  # TODO: build from source
  unpackPhase = ''
    runHook preUnpack
    mkdir -p $out/opt
    unzip $src -d $out/opt
    runHook postUnpack
  '';

  nativeBuildInputs = [
    makeBinaryWrapper
    unzip
  ];

  installPhase = ''
    runHook preInstall
    dir=$(echo $out/opt/OpenJUMP-*)

    chmod +x "$dir/bin/oj_linux.sh"
    makeWrapper "$dir/bin/oj_linux.sh" $out/bin/OpenJump \
      --set JAVA_HOME ${jre} \
      --set PATH ${
        lib.makeBinPath [
          coreutils
          gawk
          which
          gnugrep
          findutils
        ]
      }
    runHook postInstall
  '';

  meta = {
    description = "Open source Geographic Information System (GIS) written in the Java programming language";
    homepage = "http://www.openjump.org/";
    license = lib.licenses.gpl2;
    mainProgram = "OpenJump";
    maintainers = [ lib.maintainers.marcweber ];
    teams = [ lib.teams.geospatial ];
    platforms = jre.meta.platforms;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
})
