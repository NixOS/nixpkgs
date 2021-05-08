{ lib, stdenv
, fetchurl
, unzip
, jdk
, ant
, jre
, makeWrapper
, testVersion
, key
}:

# get this from the download URL when changing version
let gitRevision = "7d3deab0763c88edee4f7a08e604661e0dbdd450";

in stdenv.mkDerivation rec {
  pname = "key";
  version = "2.6.3";

  src = fetchurl {
    url = "https://formal.iti.kit.edu/key/releases/${version}/key-src-${version}_${gitRevision}.zip";
    sha256 = "1dr5jmrqs0iy76wdsfiv5hx929i24yzm1xypzqqvx7afc7apyawy";
  };

  sourceRoot = "key";

  nativeBuildInputs = [
    unzip
    jdk
    ant
    makeWrapper
  ];

  buildPhase = ''
    ant -buildfile scripts/build.xml \
      -Dgit.revision=${gitRevision} \
      compileAll deployAll
  '';

  postCheck = ''
    ant -buildfile scripts/build.xml \
      -Dgit.revision=${gitRevision} \
      compileAllTests runAllTests test-deploy-all
  '';

  installPhase = ''
    mkdir -p $out/share/java
    # Wrong version in the code. On next version change 2.5 to ${version}:
    unzip deployment/key-2.5_${gitRevision}.zip -d $out/share/java
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/KeY \
      --add-flags "-cp $out/share/java/KeY.jar de.uka.ilkd.key.core.Main"
  '';

  passthru.tests.version =
    testVersion {
      package = key;
      command = "KeY --help";
      # Wrong '2.5' version in the code. On next version change to ${version}
      version = "2.5";
    };

  meta = with lib; {
    description = "Java formal verification tool";
    homepage = "https://www.key-project.org"; # also https://formal.iti.kit.edu/key/
    longDescription = ''
      The KeY System is a formal software development tool that aims to
      integrate design, implementation, formal specification, and formal
      verification of object-oriented software as seamlessly as possible.
      At the core of the system is a novel theorem prover for the first-order
      Dynamic Logic for Java with a user-friendly graphical interface.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}

