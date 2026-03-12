{
  lib,
  stdenv,
  fetchurl,
  fetchsvn,
  jdk,
  jre,
  ant,
  makeWrapper,
  stripJavaArchivesHook,
  doCheck ? true,
  withExamples ? false,
}:

let
  deps = import ./deps.nix { inherit fetchurl; };
  testInputs = import ./testinputs.nix { inherit fetchurl; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mkgmap";
  version = "4924";

  src = fetchsvn {
    url = "https://svn.mkgmap.org.uk/mkgmap/mkgmap/trunk";
    rev = finalAttrs.version;
    hash = "sha256-4DGGAWgyIvK5pcopwlO4YDGDc73lOsL0Ljy/kFUY2As=";
  };

  patches = [
    # Disable automatic download of dependencies
    ./build.xml.patch
    ./ignore-impure-test.patch
  ];

  postPatch = ''
    # Manually create version properties file for reproducibility
    mkdir -p build/classes
    cat > build/classes/mkgmap-version.properties << EOF
      svn.version=${finalAttrs.version}
      build.timestamp=unknown
    EOF

    # Put pre-fetched dependencies into the right place
    mkdir -p lib/compile
    cp ${deps.fastutil} lib/compile/${deps.fastutil.name}
    cp ${deps.osmpbf} lib/compile/${deps.osmpbf.name}
    cp ${deps.protobuf} lib/compile/${deps.protobuf.name}
  ''
  + lib.optionalString doCheck ''
    mkdir -p lib/test
    cp ${deps.fastutil} lib/test/${deps.fastutil.name}
    cp ${deps.osmpbf} lib/test/${deps.osmpbf.name}
    cp ${deps.protobuf} lib/test/${deps.protobuf.name}
    cp ${deps.jaxb-api} lib/test/${deps.jaxb-api.name}
    cp ${deps.junit} lib/test/${deps.junit.name}
    cp ${deps.hamcrest-core} lib/test/${deps.hamcrest-core.name}

    mkdir -p test/resources/in/img
    ${lib.concatMapStringsSep "\n" (res: ''
      cp ${res} test/resources/in/${builtins.replaceStrings [ "__" ] [ "/" ] res.name}
    '') testInputs}
  '';

  nativeBuildInputs = [
    jdk
    ant
    makeWrapper
    stripJavaArchivesHook
  ];

  buildPhase = ''
    runHook preBuild
    ant
    runHook postBuild
  '';

  inherit doCheck;

  checkPhase = ''
    runHook preCheck
    ant test
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 dist/mkgmap.jar -t $out/share/java/mkgmap
    install -Dm644 dist/doc/mkgmap.1 -t $out/share/man/man1
    cp -r dist/lib/ $out/share/java/mkgmap/
    makeWrapper ${jre}/bin/java $out/bin/mkgmap \
      --add-flags "-jar $out/share/java/mkgmap/mkgmap.jar"

    ${lib.optionalString withExamples ''
      mkdir -p $out/share/mkgmap
      cp -r dist/examples $out/share/mkgmap/
    ''}

    runHook postInstall
  '';

  passthru = {
    inherit deps;
    updateScript = [
      ./update.sh
      "mkgmap"
      finalAttrs.meta.downloadPage
    ];
  };

  meta = {
    description = "Create maps for Garmin GPS devices from OpenStreetMap (OSM) data";
    downloadPage = "https://www.mkgmap.org.uk/download/mkgmap.html";
    homepage = "https://www.mkgmap.org.uk/";
    license = lib.licenses.gpl2Only;
    mainProgram = "mkgmap";
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
  };
})
