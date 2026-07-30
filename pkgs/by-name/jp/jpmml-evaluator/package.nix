{
  lib,
  maven,
  fetchFromGitHub,
  makeBinaryWrapper,
  jre_headless,
  nix-update-script,
}:

let
  pname = "jpmml-evaluator";
  version = "1.7.7";
in
maven.buildMavenPackage {
  inherit pname version;
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jpmml";
    repo = "jpmml-evaluator";
    tag = version;
    hash = "sha256-DtI/cHmiKVH0IAp3mWJr2sDDjAzM5d9/cBx4KJm74WM=";
  };

  mvnHash = "sha256-PBkRDMPF/btYROGs4bl71wl2em05N6T2Klf1qFZLHDI=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java $out/bin
    cp pmml-evaluator-example/target/pmml-evaluator-example-executable-*.jar $out/share/java/jpmml-evaluator.jar

    makeBinaryWrapper ${jre_headless}/bin/java $out/bin/jpmml-evaluator \
      --add-flags "-jar $out/share/java/jpmml-evaluator.jar"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Java Evaluator API for PMML";
    homepage = "https://github.com/jpmml/jpmml-evaluator";
    changelog = "https://github.com/jpmml/jpmml-evaluator/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.b-rodrigues ];
    mainProgram = "jpmml-evaluator";
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
