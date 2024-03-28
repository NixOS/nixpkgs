{ lib
, stdenvNoCC
, fetchurl
, nix-update-script
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "metacubexd";
  version = "1.135.1";

  src = fetchurl {
    url = "https://github.com/MetaCubeX/metacubexd/releases/download/v${finalAttrs.version}/compressed-dist.tgz";
    hash = "sha256-T7qksY6eYrTSpEToioHqttmSU7CPRJh8HAebxo2Xmpg=";
  };

  dontConfigure = true;
  dontBuild = true;

  sourceRoot = ".";
  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r ./* $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Clash.Meta Dashboard, The Official One, XD";
    homepage = "https://github.com/MetaCubeX/metacubexd";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ Guanran928 ];
  };
})
