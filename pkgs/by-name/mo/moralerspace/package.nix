{
  lib,
  stdenvNoCC,
  fetchzip,
  _experimental-update-script-combinators,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "moralerspace";
  version = "1.1.0";

  src = fetchzip {
    url = "https://github.com/yuru7/moralerspace/releases/download/v${finalAttrs.version}/Moralerspace_v${finalAttrs.version}.zip";
    hash = "sha256-sItgkidfmOPKtMx8+eaVFn8hK9cRxYShIsNXTh5dJfk=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/moralerspace

    runHook postInstall
  '';

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script { })
    (nix-update-script {
      attrPath = "moralerspace-hw";
      extraArgs = [ "--version=skip" ];
    })
    (nix-update-script {
      attrPath = "moralerspace-hwjpdoc";
      extraArgs = [ "--version=skip" ];
    })
    (nix-update-script {
      attrPath = "moralerspace-hwnf";
      extraArgs = [ "--version=skip" ];
    })
    (nix-update-script {
      attrPath = "moralerspace-jpdoc";
      extraArgs = [ "--version=skip" ];
    })
    (nix-update-script {
      attrPath = "moralerspace-nf";
      extraArgs = [ "--version=skip" ];
    })
  ];

  meta = {
    description = "Composite font of Monaspace and IBM Plex Sans JP";
    homepage = "https://github.com/yuru7/moralerspace";
    changelog = "https://github.com/yuru7/moralerspace/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ natsukium ];
    platforms = lib.platforms.all;
  };
})
