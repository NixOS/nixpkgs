{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
  nodejs,
}:

buildNpmPackage rec {
  pname = "pairdrop";
  version = "1.11.3";

  src = fetchFromGitHub {
    owner = "schlagmichdoch";
    repo = "PairDrop";
    rev = "v${version}";
    hash = "sha256-U8Bc1rTw7sBZvnvfUhDr60ZmfdBiDQhhzrTTZo6XLqU=";
  };

  npmDepsHash = "sha256-3tjTU0MqxC0wMHoavbOckoF432LSvMhQI92oXszfu0Y=";

  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec/pairdrop
    cp -r * $out/libexec/pairdrop

    # https://github.com/schlagmichdoch/PairDrop/blob/v1.10.10/.dockerignore
    rm -rf $out/libexec/pairdrop/{.github,dev,docs,licenses,pairdrop-cli,*.md,*.yml,Dockerfile,rtc_config_example.json,turnserver_example.conf}

    makeWrapper ${nodejs}/bin/node "$out/bin/pairdrop" \
      --add-flags "server/index.js" \
      --chdir "$out/libexec/pairdrop"

    runHook postInstall
  '';

  passthru = {
    tests = {
      inherit (nixosTests) pairdrop;
    };
  };

  meta = {
    description = "Local file sharing in your browser";
    mainProgram = "pairdrop";
    longDescription = ''
      PairDrop is a sublime alternative to AirDrop that works on all platforms.
      Send images, documents or text via peer to peer connection to devices in the same local network/Wi-Fi or to paired devices.
    '';
    homepage = "https://github.com/schlagmichdoch/PairDrop";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      diogotcorreia
    ];
  };
}
