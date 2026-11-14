{
  lib,
  stdenvNoCC,
  fetchzip,
  _experimental-update-script-combinators,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "moralerspace";
  version = "2.0.0";

  src = fetchzip {
    url = "https://github.com/yuru7/moralerspace/releases/download/v${finalAttrs.version}/Moralerspace_v${finalAttrs.version}.zip";
    hash = "sha256-RWpJt59Yvt/nhu6xeyR3eJKRaw+477ZXAPztt7Clt7Q=";
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
      attrPath = "moralerspace-jpdoc";
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
