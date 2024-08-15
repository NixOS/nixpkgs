{
  lib,
  stdenv,
  autoPatchelfHook,
  fetchurl,
  glib-networking,
  glibc,
  gcc-unwrapped,
  gtk3,
  openjdk17,
  libsecret,
  makeDesktopItem,
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
    gtk3
    webkitgtk
  ];
in
stdenv.mkDerivation rec {
  pname = "PortfolioPerformance";
  version = "0.70.3";

  src = fetchurl {
    url = "https://github.com/buchen/portfolio/releases/download/${version}/PortfolioPerformance-${version}-linux.gtk.x86_64.tar.gz";
    hash = "sha256-mT8cIoWTVzXyEktuybkC9sTtwlNCftiaMeyHYcyHV8A=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    gcc-unwrapped
    glib-networking
    glibc
    libsecret
  ];

  installPhase = ''
    mkdir -p $out/portfolio
    cp -av ./* $out/portfolio

    makeWrapper $out/portfolio/PortfolioPerformance $out/bin/portfolio \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --prefix PATH : ${openjdk17}/bin

    # Create desktop item
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
    mkdir -p $out/share/pixmaps
    ln -s $out/portfolio/icon.xpm $out/share/pixmaps/portfolio.xpm
  '';

  passthru.updateScript = gitUpdater { url = "https://github.com/buchen/portfolio.git"; };

  meta = with lib; {
    description = "Simple tool to calculate the overall performance of an investment portfolio";
    homepage = "https://www.portfolio-performance.info/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.epl10;
    maintainers = with maintainers; [
      kilianar
      oyren
      shawn8901
    ];
    mainProgram = "portfolio";
    platforms = [ "x86_64-linux" ];
  };
}
