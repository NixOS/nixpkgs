{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jdk,
}:

stdenv.mkDerivation rec {
  pname = "lombok";
  version = "1.18.36";

  src = fetchurl {
    url = "https://projectlombok.org/downloads/lombok-${version}.jar";
    sha256 = "sha256-c7awW2otNltwC6sI0w+U3p0zZJC8Cszlthgf70jL8Y4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  outputs = [
    "out"
    "bin"
  ];

  buildCommand = ''
    mkdir -p $out/share/java
    cp $src $out/share/java/lombok.jar

    makeWrapper ${jdk}/bin/java $bin/bin/lombok \
      --add-flags "-cp ${jdk}/lib/openjdk/lib/tools.jar:$out/share/java/lombok.jar" \
      --add-flags lombok.launch.Main
  '';

  meta = {
    description = "Library that can write a lot of boilerplate for your Java project";
    mainProgram = "lombok";
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.mit;
    homepage = "https://projectlombok.org/";
    maintainers = [ lib.maintainers.CrystalGamma ];
  };
}
