{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gradle_8,
  jdk,
  jre,
  graphviz,
  makeBinaryWrapper,
  nix-update-script,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "context-mapper-cli";
  version = "6.12.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ContextMapper";
    repo = "context-mapper-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dthz+uc6oSop5YuSho32tpeBd6RKCkbEfkB43F8Xw7I=";
  };

  nativeBuildInputs = [
    gradle_8
    jdk
    makeBinaryWrapper
  ];

  postPatch = ''
    # Release version discovery otherwise requires a Git checkout.
    substituteInPlace build.gradle \
      --replace-fail "id 'nebula.release' version '19.0.10'" "" \
      --replace-fail "group 'org.contextmapper'" "group 'org.contextmapper'
    version = '${finalAttrs.version}'"
  '';

  mitmCache = gradle_8.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleBuildTask = "installDist";
  doCheck = true;
  nativeCheckInputs = [ graphviz ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/context-mapper-cli $out/bin
    cp -r build/install/context-mapper-cli/lib $out/share/context-mapper-cli/

    makeWrapper ${jre}/bin/java $out/bin/cm \
      --prefix PATH : ${lib.makeBinPath [ graphviz ]} \
      --add-flags "-cp $out/share/context-mapper-cli/lib/* org.contextmapper.cli.ContextMapperCLI"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    mkdir -p install-check
    $out/bin/cm generate -i src/test/resources/test.cml -g context-map -o install-check
    test -s install-check/test_ContextMap.svg
    test -s install-check/test_ContextMap.png

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "cm";
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "Command-line interface to validate Context Mapper models and generate diagrams";
    homepage = "https://github.com/ContextMapper/context-mapper-cli";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    maintainers = with lib.maintainers; [ fabianhjr ];
    platforms = lib.platforms.unix;
    mainProgram = "cm";
  };
})
