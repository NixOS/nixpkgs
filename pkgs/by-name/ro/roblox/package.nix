{
  stdenvNoCC,
  lib,
  fetchzip,
  makeWrapper,
}:
let
  clientVersionUpload = "371fd838865f4799";
  hashes = {
    aarch64-darwin = "sha256-wZ+T8It/tiuj0ygSYzjj/c3/9OG7TiGUYnSQcqUecbs=";
    x86_64-darwin = "sha256-wy022LRABfgebSkqAeDRA/3RsK6dr8bMYvrdYdSoJbU=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "roblox";
  version = "0.717.0.7170982";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://setup.rbxcdn.com/mac${lib.optionalString stdenvNoCC.hostPlatform.isAarch64 "/arm64"}/version-${clientVersionUpload}-RobloxPlayer.zip";
    stripRoot = false;
    hash =
      hashes.${stdenvNoCC.hostPlatform.system}
        or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r $src/*.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Multiplayer game platform designed for playing games";
    homepage = "https://www.roblox.com";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ eveeifyeve ];
    mainProgram = "RobloxPlayer.app";
    platforms = lib.platforms.darwin;
  };
}
