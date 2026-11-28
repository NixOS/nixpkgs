{
  stdenvNoCC,
  fetchurl,
  jdk21,
  jixSource,
}:
stdenvNoCC.mkDerivation {
  pname = "jix-maven-oracle";
  version = "3.9.11";

  src = fetchurl {
    url = "https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.9.11/apache-maven-3.9.11-bin.tar.gz";
    hash = "sha256-S3GVtqT1yBr0wCEmd6Mu6BQ2Q0AbxuHoQS5rBuqCvqw=";
  };

  dontUnpack = true;
  nativeBuildInputs = [ jdk21 ];
  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    tar -xzf "$src" -C "$out"
    cp ${jixSource}/tools/oracle/Oracle.java Oracle.java
    javac --release 21 \
      -cp "$out/apache-maven-3.9.11/lib/*:$out/apache-maven-3.9.11/boot/*" \
      -d "$out" Oracle.java
    runHook postInstall
  '';
}
