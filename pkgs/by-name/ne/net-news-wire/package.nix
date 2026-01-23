{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
  makeBinaryWrapper,
}:

stdenvNoCC.mkDerivation rec {
  pname = "net-news-wire";
  version = "6.2";

  src = fetchurl {
    url = "https://github.com/Ranchero-Software/NetNewsWire/releases/download/mac-${version}/NetNewsWire${version}.zip";
    hash = "sha256-DXpC2bXgFRKYULXlrkDkwxtU77iChh5SITAIEQC5exQ=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -R NetNewsWire.app $out/Applications/
    mkdir -p $out/bin
    makeWrapper $out/Applications/NetNewsWire.app/Contents/MacOS/NetNewsWire $out/bin/net-news-wire
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
