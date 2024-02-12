{ lib
, buildNpmPackage
, fetchFromGitHub
, nodejs
}:

buildNpmPackage rec {
  pname = "pairdrop";
  version = "1.10.7";

  src = fetchFromGitHub {
    owner = "schlagmichdoch";
    repo = "PairDrop";
    rev = "v${version}";
    hash = "sha256-xHE+amWrbNfXj5J+ZxXFVsZ2wSUDAZwZKrfgPH1N68I=";
  };

  npmDepsHash = "sha256-ulqVaT28gAGwzJHQaXl6vS2tsxKjOzYufiX/ktSoeLY=";

  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib
    cp -r * $out/lib

    makeWrapper ${nodejs}/bin/node "$out/bin/pairdrop" --add-flags "index.js public --rate-limit --auto-restart"
    wrapProgram $out/bin/pairdrop --chdir "$out/lib"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Local file sharing in your browser";
    longDescription = ''
      PairDrop is a sublime alternative to AirDrop that works on all platforms.
      Send images, documents or text via peer to peer connection to devices in the same local network/Wi-Fi or to paired devices.
    '';
    homepage = "https://github.com/schlagmichdoch/PairDrop";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya ];
  };
}
