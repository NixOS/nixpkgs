{
  autoPatchelfHook,
  fetchurl,
  glib,
  glib-networking,
  gtk3,
  lib,
  libsecret,
  makeDesktopItem,
  openjdk17,
  stdenvNoCC,
  swt,
  webkitgtk,
  wrapGAppsHook3,
  gitUpdater,
}:
let
  desktopItem = makeDesktopItem {
    name = "Portfolio";
    exec = "portfolio";
    icon = "portfolio";
    comment = "Calculate Investment Portfolio Performance";
    desktopName = "Portfolio Performance";
    categories = [ "Office" ];
  };

  runtimeLibs = lib.makeLibraryPath [
    glib
    glib-networking
    gtk3
    libsecret
    swt
    webkitgtk
  ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "PortfolioPerformance";
  version = "0.71.1";

  src = fetchurl {
    url = "https://github.com/buchen/portfolio/releases/download/${finalAttrs.version}/PortfolioPerformance-${finalAttrs.version}-linux.gtk.x86_64.tar.gz";
    hash = "sha256-bZZTsL2jf4m6Gvc9cXDbAsiPoluljnb1AKshMM4325Q=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/portfolio
    cp -av ./* $out/portfolio

    makeWrapper $out/portfolio/PortfolioPerformance $out/bin/portfolio \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --prefix CLASSPATH : "${swt}/jars/swt.jar" \
      --prefix PATH : ${openjdk17}/bin

    # Create desktop item
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
    mkdir -p $out/share/pixmaps
    ln -s $out/portfolio/icon.xpm $out/share/pixmaps/portfolio.xpm
  '';

  passthru.updateScript = gitUpdater { url = "https://github.com/buchen/portfolio.git"; };

  meta = {
    description = "Simple tool to calculate the overall performance of an investment portfolio";
    homepage = "https://www.portfolio-performance.info/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.epl10;
    maintainers = with lib.maintainers; [
      kilianar
      oyren
      shawn8901
    ];
    mainProgram = "portfolio";
    platforms = [ "x86_64-linux" ];
  };
})
