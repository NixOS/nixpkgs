{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sprawling";
  version = "0.0.9-Alpha-261004";

  src = fetchurl {
    url = "https://github.com/2youg1/sprawling-agents/releases/download/v${finalAttrs.version}/sprawling-${finalAttrs.passthru.applicationVersion}-x86_64-unknown-linux-musl.zip";
    hash = "sha256-ta65E7OL/Ve97EgxchQ08LaRRPTiE4vquxhp9nGMQGw=";
  };

  nativeBuildInputs = [ unzip ];
  strictDeps = true;
  __structuredAttrs = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 sprawling "$out/bin/sprawling"
    mkdir -p "$out/${finalAttrs.passthru.resourceDir}"
    cp -R skills "$out/${finalAttrs.passthru.resourceDir}/skills"
    install -Dm644 LICENSE "$out/share/doc/${finalAttrs.pname}/LICENSE"

    runHook postInstall
  '';

  passthru = {
    applicationVersion = lib.concatStringsSep "." (
      lib.take 3 (lib.versions.splitVersion finalAttrs.version)
    );
    resourceDir = "share/${finalAttrs.pname}";
    updateScript = nix-update-script {
      extraArgs = [ "--version=unstable" ];
    };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "sprawling status";
      version = finalAttrs.passthru.applicationVersion;
    };
  };

  meta = {
    description = "Local multi-agent harness with a browser client and append-only ledger";
    homepage = "https://github.com/2youg1/sprawling-agents";
    license = lib.licenses.mpl20;
    mainProgram = "sprawling";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers._2youg1 ];
  };
})
