{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
  nodejs,
}:

buildNpmPackage rec {
  pname = "pairdrop";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "schlagmichdoch";
    repo = "PairDrop";
    rev = "v${version}";
    hash = "sha256-LvrBIdBjb4M2LidEJVCdK2uYydsJY+Cr5eXdfbS46dk=";
  };

  npmDepsHash = "sha256-Ovi5RzWPCVk6LkZ33Anb8abkyu+IrEaCXE/etBgsHYU=";

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
