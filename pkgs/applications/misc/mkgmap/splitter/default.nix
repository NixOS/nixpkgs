{ stdenv
, fetchurl
, fetchsvn
, jdk
, jre
, ant
, makeWrapper
, doCheck ? true
}:
let
  version = "597";
  sha256 = "1al3160amw0gdarrc707dsppm0kcai9mpkfak7ffspwzw9alsndx";

  deps = import ../deps.nix { inherit fetchurl; };
  testInputs = import ./testinputs.nix { inherit fetchurl; };
in
stdenv.mkDerivation {
  pname = "splitter";
  inherit version;

  src = fetchsvn {
    inherit sha256;
    url = "https://svn.mkgmap.org.uk/mkgmap/splitter/trunk";
    rev = version;
  };

  patches = [
    # Disable automatic download of dependencies
    ./build.xml.patch

    # Fix func.SolverAndProblemGeneratorTest test
    ./fix-failing-test.patch
  ];

  postPatch = with deps; ''
    substituteInPlace build.xml \
      --subst-var-by version ${version}

    mkdir -p lib/compile
    cp ${fastutil} lib/compile/${fastutil.name}
    cp ${osmpbf} lib/compile/${osmpbf.name}
    cp ${protobuf} lib/compile/${protobuf.name}
    cp ${xpp3} lib/compile/${xpp3.name}
  '' + stdenv.lib.optionalString doCheck ''
    mkdir -p lib/test
    cp ${junit} lib/test/${junit.name}
    cp ${hamcrest-core} lib/test/${hamcrest-core.name}

    mkdir -p test/resources/in/osm
    ${stdenv.lib.concatMapStringsSep "\n" (res: ''
      cp ${res} test/resources/in/${builtins.replaceStrings [ "__" ] [ "/" ] res.name}
    '') testInputs}
  '';

  nativeBuildInputs = [ jdk ant makeWrapper ];

  buildPhase = "ant";

  inherit doCheck;

  checkPhase = "ant run.tests && ant run.func-tests";

  installPhase = ''
    install -Dm644 dist/splitter.jar $out/share/java/splitter/splitter.jar
    install -Dm644 doc/splitter.1 $out/share/man/man1/splitter.1
    cp -r dist/lib/ $out/share/java/splitter/
    makeWrapper ${jre}/bin/java $out/bin/splitter \
      --add-flags "-jar $out/share/java/splitter/splitter.jar"
  '';

  meta = with stdenv.lib; {
    description = "Utility for splitting OpenStreetMap maps into tiles";
    homepage = "http://www.mkgmap.org.uk";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.all;
  };
}
