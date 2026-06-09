{
  lib,
  stdenv,
  fetchurl,
  fetchsvn,
  jdk,
  jre,
  ant,
  makeWrapper,
  mkgmap,
  stripJavaArchivesHook,
  doCheck ? true,
}:

let
  inherit (mkgmap) deps;
  testInputs = import ./testinputs.nix { inherit fetchurl; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "splitter";
  version = "654";

  src = fetchsvn {
    url = "https://svn.mkgmap.org.uk/mkgmap/splitter/trunk";
    rev = finalAttrs.version;
    hash = "sha256-y/pl8kIQ6fiF541ho72LMgJFWJdkUBqPToQGCGmmcfg=";
  };

  patches = [
    # Disable automatic download of dependencies
    ./build.xml.patch
    # Fix func.SolverAndProblemGeneratorTest test
    ./fix-failing-test.patch
  ];

  postPatch = ''
    # Manually create version properties file for reproducibility
    mkdir -p build/classes
    cat > build/classes/splitter-version.properties << EOF
      svn.version=${finalAttrs.version}
      build.timestamp=unknown
    EOF

    # Put pre-fetched dependencies into the right place
    mkdir -p lib/compile
    cp ${deps.fastutil} lib/compile/${deps.fastutil.name}
    cp ${deps.osmpbf} lib/compile/${deps.osmpbf.name}
    cp ${deps.protobuf} lib/compile/${deps.protobuf.name}
    cp ${deps.xpp3} lib/compile/${deps.xpp3.name}
  ''
  + lib.optionalString doCheck ''
    mkdir -p lib/test
    cp ${deps.junit} lib/test/${deps.junit.name}
    cp ${deps.hamcrest-core} lib/test/${deps.hamcrest-core.name}

    mkdir -p test/resources/in/osm
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
    ant run.tests
    ant run.func-tests
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 dist/splitter.jar -t $out/share/java/splitter
    install -Dm644 doc/splitter.1 -t $out/share/man/man1
    cp -r dist/lib/ $out/share/java/splitter/
    makeWrapper ${jre}/bin/java $out/bin/splitter \
      --add-flags "-jar $out/share/java/splitter/splitter.jar"

    runHook postInstall
  '';

  passthru.updateScript = [
    ./update.sh
    "mkgmap-splitter"
    finalAttrs.meta.downloadPage
  ];

  meta = {
    description = "Utility for splitting OpenStreetMap maps into tiles";
    downloadPage = "https://www.mkgmap.org.uk/download/splitter.html";
    homepage = "https://www.mkgmap.org.uk/";
    license = lib.licenses.gpl2Only;
    mainProgram = "splitter";
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
  };
})
