{ stdenvNoCC
, lib
, fetchurl
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "daytona-docker-provider-bin";
  version = "0.1.2";

  src =
    let
      urls = {
        "x86_64-linux" = {
          url = "https://download.daytona.io/daytona/providers/docker-provider/v${finalAttrs.version}/docker-provider-linux-amd64";
          hash = "sha256-nQ60Wk3KQai9ED5aorHMwfl2pX4ZNb8PLkg42rGnIXU=";
        };
        "x86_64-darwin" = {
          url = "https://download.daytona.io/daytona/providers/docker-provider/v${finalAttrs.version}/docker-provider-darwin-amd64";
          hash = "sha256-3/1EkOm2YvTpdzQjPIPB4GRiJEcbk7WH4ymzvzLbSik=";
        };
        "aarch64-linux" = {
          url = "https://download.daytona.io/daytona/providers/docker-provider/v${finalAttrs.version}/docker-provider-linux-arm64";
          hash = "sha256-Z5RAsNOg1na7qzqlHXnaJlubPgTbVjk9n9DQEilx70Y=";
        };
        "aarch64-darwin" = {
          url = "https://download.daytona.io/daytona/providers/docker-provider/v${finalAttrs.version}/docker-provider-darwin-arm64";
          hash = "sha256-j1QSRm/s+FqbzgdtbrQ8DgVD2vs9I7d6vp4Rgjq13TY=";
        };
      };
    in
    fetchurl urls."${stdenvNoCC.hostPlatform.system}";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r $src $out/bin/daytona-docker-provider
    chmod +x $out/bin/daytona-docker-provider
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
