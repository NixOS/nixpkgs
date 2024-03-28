{ stdenvNoCC
, lib
, fetchurl
, callPackage
, makeWrapper
}:

let
  dayton-bin-provider-docker = callPackage ./providers/docker { };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "daytona-bin";
  version = "0.6.0";

  src =
    let
      urls = {
        "x86_64-linux" = {
          url = "https://download.daytona.io/daytona/v${finalAttrs.version}/daytona-linux-amd64";
          hash = "sha256-w8QwFe6pB3W6Vi0MUy5js4+oowaUezg/7hbnXqak+5U=";
        };
        "x86_64-darwin" = {
          url = "https://download.daytona.io/daytona/v${finalAttrs.version}/daytona-darwin-amd64";
          hash = "sha256-t7MPRFMBlDBHsDoUhbryNs+O2unsF3ajm3jhGTeM9+g=";
        };
        "aarch64-linux" = {
          url = "https://download.daytona.io/daytona/v${finalAttrs.version}/daytona-linux-arm64";
          hash = "sha256-PuvGZ0ZM+lCWVUT5/NgpyiRy/L1aVUmGdz0YermiE8o=";
        };
        "aarch64-darwin" = {
          url = "https://download.daytona.io/daytona/v${finalAttrs.version}/daytona-darwin-arm64";
          hash = "sha256-TI7JST3Ir7eykCtR9At5JgOQwT5/f4BC0nlGZhWeVQY=";
        };
      };
    in
    fetchurl urls."${stdenvNoCC.hostPlatform.system}";

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    dayton-bin-provider-docker
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/daytona/providers
    cp -r $src $out/bin/daytona
    chmod +x $out/bin/daytona
    cp ${dayton-bin-provider-docker}/bin/daytona-docker-provider $out/share/daytona/providers/
    wrapProgram $out/bin/daytona \
        --set DEFAULT_PROVIDERS_DIR $out/share/daytona/providers
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
