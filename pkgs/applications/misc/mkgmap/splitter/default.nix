{ lib
, stdenv
, fetchurl
, fetchsvn
, jdk
, jre
, ant
, makeWrapper
, stripJavaArchivesHook
, doCheck ? true
}:
let
  deps = import ../deps.nix { inherit fetchurl; };
  testInputs = import ./testinputs.nix { inherit fetchurl; };
in
stdenv.mkDerivation rec {
  pname = "splitter";
  version = "653";

  src = fetchsvn {
    url = "https://svn.mkgmap.org.uk/mkgmap/splitter/trunk";
    rev = version;
    sha256 = "sha256-iw414ecnOfeG3FdlIaoVOPv9BXZ95uUHuPzCQGH4G+A=";
  };

  patches = [
    # Disable automatic download of dependencies
    ./build.xml.patch
    # Fix func.SolverAndProblemGeneratorTest test
    ./fix-failing-test.patch
  ];

  postPatch = with deps; ''
    # Manually create version properties file for reproducibility
    mkdir -p build/classes
    cat > build/classes/splitter-version.properties << EOF
      svn.version=${version}
      build.timestamp=unknown
    EOF

    # Put pre-fetched dependencies into the right place
    mkdir -p lib/compile
    cp ${fastutil} lib/compile/${fastutil.name}
    cp ${osmpbf} lib/compile/${osmpbf.name}
    cp ${protobuf} lib/compile/${protobuf.name}
    cp ${xpp3} lib/compile/${xpp3.name}
  '' + lib.optionalString doCheck ''
    mkdir -p lib/test
    cp ${junit} lib/test/${junit.name}
    cp ${hamcrest-core} lib/test/${hamcrest-core.name}

    mkdir -p test/resources/in/osm
    ${lib.concatMapStringsSep "\n" (res: ''
      cp ${res} test/resources/in/${builtins.replaceStrings [ "__" ] [ "/" ] res.name}
    '') testInputs}
  '';

  nativeBuildInputs = [ jdk ant makeWrapper stripJavaArchivesHook ];

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

  passthru.updateScript = [ ../update.sh "mkgmap-splitter" meta.downloadPage ];

  meta = with lib; {
    description = "Utility for splitting OpenStreetMap maps into tiles";
    downloadPage = "https://www.mkgmap.org.uk/download/splitter.html";
    homepage = "https://www.mkgmap.org.uk/";
    license = licenses.gpl2Only;
    mainProgram = "splitter";
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
  };
}
