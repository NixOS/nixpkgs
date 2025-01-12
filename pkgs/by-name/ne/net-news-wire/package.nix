{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
}:

stdenvNoCC.mkDerivation rec {
  pname = "net-news-wire";
  version = "6.1.8";

  src = fetchurl {
    url = "https://github.com/Ranchero-Software/NetNewsWire/releases/download/mac-${version}/NetNewsWire${version}.zip";
    hash = "sha256-/xhy0gF2YHYBVPUAlwySH0/yIelMNeFlU7Ya/ADx1NI=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -R NetNewsWire.app $out/Applications/
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^mac-(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = {
    description = "RSS reader for macOS and iOS";
    longDescription = ''
      It's like podcasts — but for reading.
      NetNewsWire shows you articles from your favorite blogs and news sites and keeps track of what you've read.
    '';
    homepage = "https://github.com/Ranchero-Software/NetNewsWire";
    changelog = "https://github.com/Ranchero-Software/NetNewsWire/releases/tag/mac-${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      jakuzure
      DimitarNestorov
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
