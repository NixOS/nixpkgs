{ lib, stdenv
, fetchurl
, fetchsvn
, substituteAll
, jdk
, jre
, ant
, makeWrapper
, doCheck ? true
, withExamples ? false
}:
let
  deps = import ./deps.nix { inherit fetchurl; };
  testInputs = import ./testinputs.nix { inherit fetchurl; };
in
stdenv.mkDerivation rec {
  pname = "mkgmap";
  version = "4914";

  src = fetchsvn {
    url = "https://svn.mkgmap.org.uk/mkgmap/mkgmap/trunk";
    rev = version;
    sha256 = "sha256-aA5jGW6GTo2OvFZ/uPA4KpS+SjNB/tRGwgj1oM7zywU=";
  };

  patches = [
    (substituteAll {
      # Disable automatic download of dependencies
      src = ./build.xml.patch;
      inherit version;
    })
  ];

  postPatch = with deps; ''
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

  nativeBuildInputs = [ jdk ant makeWrapper ];

  buildPhase = "ant";

  inherit doCheck;

  checkPhase = "ant test";

  installPhase = ''
    install -Dm644 dist/mkgmap.jar -t $out/share/java/mkgmap
    install -Dm644 dist/doc/mkgmap.1 -t $out/share/man/man1
    cp -r dist/lib/ $out/share/java/mkgmap/
    makeWrapper ${jre}/bin/java $out/bin/mkgmap \
      --add-flags "-jar $out/share/java/mkgmap/mkgmap.jar"
  '' + lib.optionalString withExamples ''
    mkdir -p $out/share/mkgmap
    cp -r dist/examples $out/share/mkgmap/
  '';

  passthru.updateScript = [ ./update.sh "mkgmap" meta.downloadPage ];

  meta = with lib; {
    description = "Create maps for Garmin GPS devices from OpenStreetMap (OSM) data";
    homepage = "https://www.mkgmap.org.uk/";
    downloadPage = "https://www.mkgmap.org.uk/download/mkgmap.html";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.all;
  };
}
