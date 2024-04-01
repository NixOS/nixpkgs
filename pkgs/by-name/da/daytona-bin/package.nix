{ stdenvNoCC
, lib
, fetchurl
, makeWrapper
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "daytona-bin";
  version = "0.9.0";

  src =
    let
      urls = {
        "x86_64-linux" = {
          url = "https://download.daytona.io/daytona/v${finalAttrs.version}/daytona-linux-amd64";
          hash = "sha256-vJVGFmaGP9oCCzdvhuAPsoTaxzGvdDKDupMYuepRUCA=";
        };
        "x86_64-darwin" = {
          url = "https://download.daytona.io/daytona/v${finalAttrs.version}/daytona-darwin-amd64";
          hash = "sha256-R63AQVt5DudzJub+TYcJiHkBGVeOhjvgJZgnqvJb8t0=";
        };
        "aarch64-linux" = {
          url = "https://download.daytona.io/daytona/v${finalAttrs.version}/daytona-linux-arm64";
          hash = "sha256-98OEhJ1gakPTVO73M9WW0QuSDgR42gNjoioEkkNbf6w=";
        };
        "aarch64-darwin" = {
          url = "https://download.daytona.io/daytona/v${finalAttrs.version}/daytona-darwin-arm64";
          hash = "sha256-YmLyioFueEfi/2Q+JwINDhkwo617/KUZrimz9CibdA8=";
        };
      };
    in
    fetchurl urls."${stdenvNoCC.hostPlatform.system}";

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/daytona
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/daytonaio/daytona/releases/tag/v${finalAttrs.version}";
    description = "The Open Source Dev Environment Manager";
    homepage = "https://github.com/daytonaio/daytona";
    license = lib.licenses.asl20;
    mainProgram = "daytona";
    maintainers = with lib.maintainers; [ ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
