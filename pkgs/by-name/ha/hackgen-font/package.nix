{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hackgen-font";
  version = "2.10.0";

  src = fetchzip {
    url = "https://github.com/yuru7/HackGen/releases/download/v${finalAttrs.version}/HackGen_v${finalAttrs.version}.zip";
    hash = "sha256-cIFrYfjPLspXYfaiITmlIMes6dP9fwjJ59wD9FLO0OU=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/hackgen

    runHook postInstall
  '';

  meta = with lib; {
    description = "Composite font of Hack and GenJyuu-Goghic";
    homepage = "https://github.com/yuru7/HackGen";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ natsukium ];
  };
})
