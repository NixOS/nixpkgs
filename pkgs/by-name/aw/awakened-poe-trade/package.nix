{
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
  libxtst,
  libxt,
  nix-update-script,
  commandLineArgs ? [ ],
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "awakened-poe-trade";
  version = "3.30.102";

  src = fetchurl {
    url = "https://github.com/SnosMe/awakened-poe-trade/releases/download/v${finalAttrs.version}/Awakened-PoE-Trade-${finalAttrs.version}.AppImage";
    hash = "sha256-h/hTWuuvFvHX+lvFSWc8rAd5Eeylp3eZBDzWkWu7zGM=";
  };

  extraPkgs = _: [
    libxtst
    libxt
  ];

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp -a ${finalAttrs.contents}/awakened-poe-trade.desktop $out/share/applications/
    cp -a ${finalAttrs.contents}/usr/share/icons $out/share

    substituteInPlace $out/share/applications/awakened-poe-trade.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=awakened-poe-trade ${lib.escapeShellArgs commandLineArgs}'

    ${lib.optionalString (commandLineArgs != [ ]) ''
      wrapProgram $out/bin/awakened-poe-trade \
        --add-flags ${lib.escapeShellArgs commandLineArgs}
    ''}
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Path of Exile trading app for price checking";
    homepage = "https://github.com/SnosMe/awakened-poe-trade";
    changelog = "https://github.com/SnosMe/awakened-poe-trade/releases/tag/v${finalAttrs.version}";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mreichardt95
    ];
    platforms = with lib.platforms; linux;
    mainProgram = "awakened-poe-trade";
  };
})
