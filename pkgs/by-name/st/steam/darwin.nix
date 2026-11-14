{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "steam";
  version = "6.1";

  src = fetchurl {
    url = "https://client-update.fastly.steamstatic.com/appdmg_osx.zip.984652b88a9737e3f4e77c656d9ffa67d5042c2c";
    hash = "sha256-i/TOi0vLxQ9kKYjJVVWfYF56h3NyEW56Kz/RNVAEvts=";
  };

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

  dontFixup = true;

  unpackPhase = ''
    runHook preUnpack

    unzip -qq "$src"
    tar -xzf SteamMacBootstrapper.tar.gz
    find . -name '._*' -delete

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R Steam.app "$out/Applications/"

    makeWrapper "$out/Applications/Steam.app/Contents/MacOS/steam_osx" "$out/bin/steam"

    runHook postInstall
  '';

  passthru.updateScript = ./update.py;

  meta = {
    description = "Digital distribution platform";
    longDescription = ''
      Steam is a video game digital distribution service and storefront from Valve.
    '';
    homepage = "https://store.steampowered.com/";
    license = lib.licenses.unfreeRedistributable;
    teams = with lib.teams; [ steam ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.darwin;
    mainProgram = "steam";
    mainDarwinApp = "Steam.app";
  };
})
