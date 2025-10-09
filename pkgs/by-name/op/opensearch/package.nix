{
  coreutils,
  fetchurl,
  gnugrep,
  jre_headless,
  lib,
  makeBinaryWrapper,
  nixosTests,
  stdenv,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opensearch";
  version = "2.19.2";

  src = fetchurl {
    url = "https://artifacts.opensearch.org/releases/bundle/opensearch/${finalAttrs.version}/opensearch-${finalAttrs.version}-linux-x64.tar.gz";
    hash = "sha256-EaOx8vs3y00ln7rUiaCGoD+HhiQY4bhQAzu18VfaTYw=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  buildInputs = [
    jre_headless
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R bin config lib modules plugins $out

    substituteInPlace $out/bin/opensearch \
      --replace 'bin/opensearch-keystore' "$out/bin/opensearch-keystore"

    wrapProgram $out/bin/opensearch \
      --prefix PATH : "${
        lib.makeBinPath [
          gnugrep
          coreutils
        ]
      }" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [ stdenv.cc.cc ]
      }:$out/plugins/opensearch-knn/lib/" \
      --set JAVA_HOME "${jre_headless}"

    wrapProgram $out/bin/opensearch-plugin --set JAVA_HOME "${jre_headless}"

    rm $out/bin/opensearch-cli

    runHook postInstall
  '';

  passthru.tests = nixosTests.opensearch;

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    homepage = "https://github.com/opensearch-project/OpenSearch";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
  };
})
