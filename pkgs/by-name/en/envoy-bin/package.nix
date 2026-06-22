{
  lib,
  stdenvNoCC,
  autoPatchelfHook,
  fetchurl,
  nixosTests,
  versionCheckHook,
}:
let
  version = "1.38.2";
  inherit (stdenvNoCC.hostPlatform) system;
  throwSystem = throw "envoy-bin is not available for ${system}.";

  plat =
    {
      aarch64-linux = "aarch_64";
      x86_64-linux = "x86_64";
    }
    .${system} or throwSystem;

  hash =
    {
      aarch64-linux = "sha256-nHFdDu2KrzqZgw7glwvDtevH1CIbvB4vP/chBWHanX0=";
      x86_64-linux = "sha256-h3RKH8mY1ncHjJcDEToZLQgwutxoiGYkQWMoR/yziJk=";
    }
    .${system} or throwSystem;
in
stdenvNoCC.mkDerivation {
  pname = "envoy-bin";
  inherit version;

  src = fetchurl {
    url = "https://github.com/envoyproxy/envoy/releases/download/v${version}/envoy-${version}-linux-${plat}";
    inherit hash;
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  strictDeps = true;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 $src $out/bin/envoy

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    tests.envoy-bin = nixosTests.envoy-bin;

    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://envoyproxy.io";
    changelog = "https://github.com/envoyproxy/envoy/releases/tag/v${version}";
    description = "Cloud-native edge and service proxy";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [
      charludo
    ];
    mainProgram = "envoy";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
