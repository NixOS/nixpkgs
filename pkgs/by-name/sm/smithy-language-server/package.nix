{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  jre,
  gradle,
  runCommand,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "smithy-language-server";
  version = "0.9.0";

  strictDeps = true;

  # Setting to true breaks mitmCache.updateScript
  __structuredAttrs = false;

  src = fetchFromGitHub {
    owner = "smithy-lang";
    repo = "smithy-language-server";
    tag = finalAttrs.version;
    hash = "sha256-BnnZKADY9HiSy8mlwuh+e7g6Zz422l/rx1NTSRgexIU=";
  };

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  gradleBuildTask = "installDist";

  # NOTE: in 0.9.0, test ProjectLoaderTest.loadsProjectWithMavenDep() is failing.
  # Once the test is fixed, checking should be re-enabled.
  # doCheck = true;

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/smithy-language-server}
    cp -r build/install/smithy-language-server/lib $out/share/smithy-language-server/

    makeWrapper ${lib.getExe jre} $out/bin/smithy-language-server \
      --set CLASSPATH "$out/share/smithy-language-server/lib/*" \
      --add-flags "software.amazon.smithy.lsp.Main"

    runHook postInstall
  '';

  passthru.tests = {
    help = runCommand "${finalAttrs.pname}-help-test" { } ''
      ${lib.getExe finalAttrs.finalPackage} --help &> $out
      grep "Run the Smithy Language Server" $out
    '';
  };

  meta = {
    mainProgram = "smithy-language-server";
    description = "Language server implementation for the Smithy IDL";
    homepage = "https://github.com/smithy-lang/smithy-language-server";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yoquec ];
    inherit (jre.meta) platforms;
  };
})
