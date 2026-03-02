{
  lib,
  fetchurl,
  stdenv,
  appimageTools,
  makeWrapper,
  electron,
  libxtst,
  libxt,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "awakened-poe-trade";
  version = "3.27.106";

  src = fetchurl {
    url = "https://github.com/SnosMe/awakened-poe-trade/releases/download/v${finalAttrs.version}/Awakened-PoE-Trade-${finalAttrs.version}.AppImage";
    hash = "sha256-8L5Szn0KYfUMaTe+yyhJV1YZspmJCSlXSHXLPoiRhjE=";
  };

  passthru = {
    appImageContents = appimageTools.extractType2 {
      inherit (finalAttrs) pname src version;
    };

    updateScript = nix-update-script { };
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/awakened-poe-trade $out/share/applications

    cp -a ${finalAttrs.passthru.appImageContents}/{locales,resources} $out/share/awakened-poe-trade
    cp -a ${finalAttrs.passthru.appImageContents}/awakened-poe-trade.desktop $out/share/applications/
    cp -a ${finalAttrs.passthru.appImageContents}/usr/share/icons $out/share

    substituteInPlace $out/share/applications/awakened-poe-trade.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=awakened-poe-trade'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${lib.getExe electron} $out/bin/awakened-poe-trade \
      --add-flags $out/share/awakened-poe-trade/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libxtst
          libxt
        ]
      }"
  '';

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
