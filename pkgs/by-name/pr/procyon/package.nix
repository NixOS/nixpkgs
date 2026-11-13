{
  lib,
  stdenv,
  fetchFromGitHub,
  makeShellWrapper,
  jdk_headless,
  jre_minimal,
  gradle,
}:

let
  jre = jre_minimal.override {
    modules = [
      "java.base"
      "java.compiler"
      "java.logging"
    ];
  };
  jcommander-src = fetchFromGitHub {
    owner = "cbeust";
    repo = "jcommander";
    tag = "1.78";
    hash = "sha256-zoPymohdU8HhVmw7ACoPbgNGgzdsIDVD3bl7Fh3qf2g=";
  };
in

stdenv.mkDerivation rec {
  pname = "procyon";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mstrobel";
    repo = "procyon";
    tag = "v${version}";
    hash = "sha256-l8+eEdJtneZY1s6rvh9h87XwL7ioU3Y9T64CH7LdjXo=";
  };

  postPatch = ''
    sed -i build.gradle \
      -e '/subprojects {/,/^}/d' \
      -e '/uploadArchives/d' \
      -e "/'maven'/d" \
      -e '/sourceCompatibility/d'
    sed -i -e 's/compile /implementation /' -e 's/testCompile/testImplementation/' {.,*}/build.gradle
    sed -i Procyon.Decompiler/build.gradle \
      -e '/uploadArchives/d' \
      -e 's/configurations.compile/configurations.runtimeClasspath/' \
      -e "/jcommander/d"
    cp -a ${jcommander-src}/src Procyon.Decompiler
  '';

  nativeBuildInputs = [
    jdk_headless
    gradle
    makeShellWrapper
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/procyon
    mv build/Procyon.Decompiler/libs/Procyon.Decompiler-${version}.jar $out/share/procyon/procyon-decompiler.jar

    makeWrapper ${jre}/bin/java $out/bin/procyon \
      --add-flags "-jar $out/share/procyon/procyon-decompiler.jar"
  '';

  meta = {
    description = "Suite of Java metaprogramming tools including a Java decompiler";
    homepage = "https://github.com/mstrobel/procyon/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ linsui ];
    mainProgram = "procyon";
  };
}
