{ lib
, stdenvNoCC
, fetchFromGitHub
, jdk8
, jre8
, strip-nondeterminism
, makeWrapper
, zip
}:

let
  jdk = jdk8;
  jre = jre8;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "astral";
  version = "5.7.1";

  src = fetchFromGitHub {
    owner = "smirarab";
    repo = "ASTRAL";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VhcsX9BxiZ0nISN6Xe4N+kq0iBMCtNhyxDrm9cwXfBA=";
  };

  patches = [
    # we can't use stripJavaArchivesHook here, because the build process puts a .jar file into a zip file
    # this patch calls strip-nondeterminism manually
    ./make-deterministic.patch
  ];

  nativeBuildInputs = [
    jdk
    zip
    strip-nondeterminism
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    patchShebangs ./make.sh
    ./make.sh
    runHook postBuild
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    java -jar astral.${finalAttrs.version}.jar -i main/test_data/song_primates.424.gene.tre
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 astral.${finalAttrs.version}.jar -t $out/share
    install -Dm644 lib/*.jar -t $out/share/lib
    install -Dm644 Astral.${finalAttrs.version}.zip -t $out/share
    cp -a main/test_data $out/share

    makeWrapper ${jre}/bin/java $out/bin/astral \
        --add-flags "-jar $out/share/astral.${finalAttrs.version}.jar"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/smirarab/ASTRAL";
    description = "Tool for estimating an unrooted species tree given a set of unrooted gene trees";
    mainProgram = "astral";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # source bundles dependencies as jars
    ];
    license = licenses.asl20;
    maintainers = with maintainers; [ bzizou tomasajt ];
  };
})
