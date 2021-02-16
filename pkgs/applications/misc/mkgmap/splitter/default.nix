{ lib, stdenv
, fetchurl
, substituteAll
, jdk
, jre
, ant
, makeWrapper
, doCheck ? true
}:
let
  deps = import ../deps.nix { inherit fetchurl; };
  testInputs = import ./testinputs.nix { inherit fetchurl; };
in
stdenv.mkDerivation rec {
  pname = "splitter";
  version = "598";

  src = fetchurl {
    url = "http://www.mkgmap.org.uk/download/splitter-r${version}-src.tar.gz";
    sha256 = "gpbJpDBXA9tmSmx9oKLa7xWtIOHBTYd1iPPgNTC2C2M=";
  };

  patches = [
    (substituteAll {
      # Disable automatic download of dependencies
      src = ./build.xml.patch;
      inherit version;
    })

    # Fix func.SolverAndProblemGeneratorTest test
    ./fix-failing-test.patch
  ];

  postPatch = with deps; ''
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

  nativeBuildInputs = [ jdk ant makeWrapper ];

  buildPhase = "ant";

  inherit doCheck;

  checkPhase = "ant run.tests && ant run.func-tests";

  installPhase = ''
    install -Dm644 dist/splitter.jar -t $out/share/java/splitter
    install -Dm644 doc/splitter.1 -t $out/share/man/man1
    cp -r dist/lib/ $out/share/java/splitter/
    makeWrapper ${jre}/bin/java $out/bin/splitter \
      --add-flags "-jar $out/share/java/splitter/splitter.jar"
  '';

  passthru.updateScript = [ ../update.sh "mkgmap-splitter" meta.downloadPage ];

  meta = with lib; {
    description = "Utility for splitting OpenStreetMap maps into tiles";
    homepage = "http://www.mkgmap.org.uk";
    downloadPage = "http://www.mkgmap.org.uk/download/splitter.html";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.all;
  };
}
