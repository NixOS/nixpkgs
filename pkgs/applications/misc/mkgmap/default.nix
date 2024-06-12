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
, withExamples ? false
}:
let
  deps = import ./deps.nix { inherit fetchurl; };
  testInputs = import ./testinputs.nix { inherit fetchurl; };
in
stdenv.mkDerivation rec {
  pname = "mkgmap";
  version = "4919";

  src = fetchsvn {
    url = "https://svn.mkgmap.org.uk/mkgmap/mkgmap/trunk";
    rev = version;
    sha256 = "sha256-WMFZEGTXVAaBlEKUqclmkw3pKnWSdbvulDvSi7TQn8k=";
  };

  patches = [
    # Disable automatic download of dependencies
    ./build.xml.patch
    ./ignore-impure-test.patch
  ];

  postPatch = with deps; ''
    # Manually create version properties file for reproducibility
    mkdir -p build/classes
    cat > build/classes/mkgmap-version.properties << EOF
      svn.version=${version}
      build.timestamp=unknown
    EOF

    # Put pre-fetched dependencies into the right place
    mkdir -p lib/compile
    cp ${fastutil} lib/compile/${fastutil.name}
    cp ${osmpbf} lib/compile/${osmpbf.name}
    cp ${protobuf} lib/compile/${protobuf.name}
  '' + lib.optionalString doCheck ''
    mkdir -p lib/test
    cp ${fastutil} lib/test/${fastutil.name}
    cp ${osmpbf} lib/test/${osmpbf.name}
    cp ${protobuf} lib/test/${protobuf.name}
    cp ${jaxb-api} lib/test/${jaxb-api.name}
    cp ${junit} lib/test/${junit.name}
    cp ${hamcrest-core} lib/test/${hamcrest-core.name}

    mkdir -p test/resources/in/img
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

  passthru.updateScript = [ ./update.sh "mkgmap" meta.downloadPage ];

  meta = with lib; {
    description = "Create maps for Garmin GPS devices from OpenStreetMap (OSM) data";
    downloadPage = "https://www.mkgmap.org.uk/download/mkgmap.html";
    homepage = "https://www.mkgmap.org.uk/";
    license = licenses.gpl2Only;
    mainProgram = "mkgmap";
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
  };

}
