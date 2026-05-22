{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  glibc,
}:

let
  version = "1.0.1";
  buildId = "5826024320139264";

  sources = {
    x86_64-linux = {
      url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/${version}-${buildId}/linux-x64/cli_linux_x64.tar.gz";
      hash = "sha512-vhF0oWXQa/Qf+3yxMAABRncfOEhrAFpopDxeYJH6gDIbOovNXTJeGJgftkiHC1lf9WMQgC1/kbsO2OdDJmhFOg==";
    };
    aarch64-linux = {
      url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/${version}-${buildId}/linux-arm/cli_linux_arm64.tar.gz";
      hash = "sha512-pVxabP+Xlpl9EEtxMPw7K59PAc9hvmBrbNGSnknSIfLaMmWRUuE720cH/X0cUB0q1y4RwImn6niHzNHGW+sGcg==";
    };
    x86_64-darwin = {
      url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/${version}-${buildId}/darwin-x64/cli_mac_x64.tar.gz";
      hash = "sha512-14L4wyJYIQlEBQeQjDoRJCDmH+3FZ+2ATyDyOcLzNkEFMmwIzK2f5ubuqWHB8PHkLrfQaAd9Dc06820XSISbmw==";
    };
    aarch64-darwin = {
      url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/${version}-${buildId}/darwin-arm/cli_mac_arm64.tar.gz";
      hash = "sha512-bgvIqJlmgNBvtwz25S07jA2ga87ulxBsPXZybq7oyU7AOFeY68hf4AGAiMlP483SP7YfvTnsIHq5WJgMmF0O8A==";
    };
  };
in
stdenv.mkDerivation {
  pname = "antigravity-cli";
  inherit version;

  src = fetchurl (
    sources.${stdenv.hostPlatform.system}
      or (throw "antigravity-cli: unsupported system ${stdenv.hostPlatform.system}")
  );

  sourceRoot = ".";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glibc
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 antigravity "$out/bin/antigravity"
    ln -s antigravity "$out/bin/agy"
    runHook postInstall
  '';

  meta = {
    description = "Google's agentic development platform CLI";
    homepage = "https://antigravity.google";
    license = lib.licenses.unfree;
    mainProgram = "antigravity";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
  };
}
