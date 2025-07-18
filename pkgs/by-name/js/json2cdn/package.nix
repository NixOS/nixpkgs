{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_8,
  jre_headless,
  makeBinaryWrapper,
  tests,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "json2cdn";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "uku3lig";
    repo = "json2cdn";
    tag = finalAttrs.version;
    hash = "sha256-pHmzeZHZyr3FyfkXwrdPk+lcHQKH6t4pnDD9ImMgSV8=";
  };

  nativeBuildInputs = [
    gradle_8
    makeBinaryWrapper
  ];

  mitmCache = gradle_8.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  # this is required for using mitm-cache on Darwin
  __darwinAllowLocalNetworking = true;

  gradleBuildTask = "shadowJar";

  installPhase = ''
    runHook preInstall

    install -Dm644 build/libs/json2cdn-${finalAttrs.version}-all.jar $out/lib/json2cdn.jar

    makeWrapper ${lib.getExe jre_headless} $out/bin/json2cdn --add-flags "-jar $out/lib/json2cdn.jar"

    runHook postInstall
  '';

  passthru = {
    tests.formats-cdn = tests.pkgs-lib.formats.passthru.entries.pass-cdnAtoms;
  };

  meta = {
    description = "Converts a JSON file to dzikoysk's CDN format";
    homepage = "https://github.com/uku3lig/json2cdn";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ uku3lig ];
    inherit (jre_headless.meta) platforms;
    mainProgram = "json2cdn";
  };
})
