{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
}:

buildNpmPackage rec {
  pname = "pairdrop";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "schlagmichdoch";
    repo = "PairDrop";
    rev = "v${version}";
    hash = "sha256-Ovro5vMf28Wz6srEmUYOMFZE746/mcEDcs+f8rG7X+g=";
  };

  npmDepsHash = "sha256-vxH0YmSS3CXOrMQ4Tue8jcwjTZNfiT2Lnhs0O6xrfpQ=";

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

  meta = with lib; {
    description = "Local file sharing in your browser";
    mainProgram = "pairdrop";
    longDescription = ''
      PairDrop is a sublime alternative to AirDrop that works on all platforms.
      Send images, documents or text via peer to peer connection to devices in the same local network/Wi-Fi or to paired devices.
    '';
    homepage = "https://github.com/schlagmichdoch/PairDrop";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      diogotcorreia
      dit7ya
    ];
  };
}
