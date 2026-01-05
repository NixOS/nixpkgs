{
  lib,
  jdk,
  stdenv,
  gradle,
  makeWrapper,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: rec {
  pname = "groovy-language-server";
  version = "0-unstable-2025-12-03";

  src = fetchFromGitHub {
    name = "${pname}-${version}";
    owner = "GroovyLanguageServer";
    repo = "groovy-language-server";
    rev = "0746b250604c0a75bf620f7257aed8df12d025c3";
    sha256 = "sha256-rLi6xvGFVRvAVmP59Te1MxKA6HzQ+qPtEC5lMws5tFQ=";
  };

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleFlags = [ "-Dfile.encoding=utf-8" ];

  gradleBuildTask = "shadowJar";

  doCheck = true;

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  buildInputs = [
    jdk
  ];

  installPhase = ''
    mkdir -p $out/share/java
    mkdir -p $out/bin

    cp build/libs/${pname}-${version}-all.jar $out/share/java

    makeWrapper "${jdk}/bin/java" "$out/bin/${pname}" \
    --add-flags "-jar $out/share/java/${pname}-${version}-all.jar" \
    --set CLASSPATH "$out/share/java/${pname}-${version}-all.jar:\$CLASSPATH"
  '';

  meta = with lib; {
    homepage = "https://github.com/GroovyLanguageServer/groovy-language-server";
    description = "Groovy Language Server";
    longDescription = "Groovy Language Server";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ lib.maintainers.guilvareux ];
  };
})
