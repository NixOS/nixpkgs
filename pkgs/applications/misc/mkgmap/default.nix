{ stdenv
, fetchurl
, fetchsvn
, jdk
, jre
, ant
, makeWrapper
, doCheck ? true
, withExamples ? false
}:
let
  version = "4565";
  sha256 = "0cfh0msky5812l28mavy6p3k2zgyxb698xk79mvla9l45zcicnvw";

  deps = import ./deps.nix { inherit fetchurl; };
  testInputs = import ./testinputs.nix { inherit fetchurl; };
in
stdenv.mkDerivation {
  pname = "mkgmap";
  inherit version;

  src = fetchsvn {
    inherit sha256;
    url = "https://svn.mkgmap.org.uk/mkgmap/mkgmap/trunk";
    rev = version;
  };

  patches = [
    # Disable automatic download of dependencies
    ./build.xml.patch

    # Fix testJavaRules test
    ./fix-failing-test.patch
  ];

  postPatch = with deps; ''
    substituteInPlace build.xml \
      --subst-var-by version ${version}

    mkdir -p lib/compile
    cp ${fastutil} lib/compile/${fastutil.name}
    cp ${osmpbf} lib/compile/${osmpbf.name}
    cp ${protobuf} lib/compile/${protobuf.name}
  '' + stdenv.lib.optionalString doCheck ''
    mkdir -p lib/test
    cp ${fastutil} lib/test/${fastutil.name}
    cp ${osmpbf} lib/test/${osmpbf.name}
    cp ${protobuf} lib/test/${protobuf.name}
    cp ${jaxb-api} lib/test/${jaxb-api.name}
    cp ${junit} lib/test/${junit.name}
    cp ${hamcrest-core} lib/test/${hamcrest-core.name}

    mkdir -p test/resources/in/img
    ${stdenv.lib.concatMapStringsSep "\n" (res: ''
      cp ${res} test/resources/in/${builtins.replaceStrings [ "__" ] [ "/" ] res.name}
    '') testInputs}
  '';

  nativeBuildInputs = [ jdk ant makeWrapper ];

  buildPhase = "ant";

  inherit doCheck;

  checkPhase = "ant test";

  installPhase = ''
    install -Dm644 dist/mkgmap.jar $out/share/java/mkgmap/mkgmap.jar
    install -Dm644 dist/doc/mkgmap.1 $out/share/man/man1/mkgmap.1
    cp -r dist/lib/ $out/share/java/mkgmap/
    makeWrapper ${jre}/bin/java $out/bin/mkgmap \
      --add-flags "-jar $out/share/java/mkgmap/mkgmap.jar"
  '' + stdenv.lib.optionalString withExamples ''
    mkdir -p $out/share/mkgmap
    cp -r dist/examples $out/share/mkgmap/
  '';

  meta = with stdenv.lib; {
    description = "Create maps for Garmin GPS devices from OpenStreetMap (OSM) data";
    homepage = "http://www.mkgmap.org.uk";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.all;
  };
}
