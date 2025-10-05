{
  autoPatchelfHook,
  fetchurl,
  glib,
  glib-networking,
  gtk3,
  lib,
  libsecret,
  makeDesktopItem,
  openjdk21,
  stdenvNoCC,
  webkitgtk_4_1,
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
    startupWMClass = "Portfolio Performance";
  };

  runtimeLibs = lib.makeLibraryPath [
    glib
    glib-networking
    gtk3
    libsecret
    webkitgtk_4_1
  ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "PortfolioPerformance";
  version = "0.80.2";

  src = fetchurl {
    url = "https://github.com/buchen/portfolio/releases/download/${finalAttrs.version}/PortfolioPerformance-${finalAttrs.version}-linux.gtk.x86_64.tar.gz";
    hash = "sha256-v6XtXClqihubYSr8trX4w9sNpRqaBsTFf0mI7a1m7Jc=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/portfolio
    cp -av ./* $out/portfolio

    # Remove all jna plugins that does not match the system
    rm -fR $out/portfolio/plugins/com.sun.jna*/com/sun/jna/{\
    aix-ppc,\
    aix-ppc64,\
    darwin-aarch64,\
    darwin-x86-64,\
    dragonflybsd-x86-64,\
    freebsd-aarch64,\
    freebsd-x86,\
    freebsd-x86-64,\
    linux-aarch64,\
    linux-arm,\
    linux-armel,\
    linux-loongarch64,\
    linux-mips64el,\
    linux-ppc,\
    linux-ppc64le,\
    linux-riscv64,\
    linux-s390x,\
    linux-x86,\
    openbsd-x86,\
    openbsd-x86-64,\
    sunos-sparc,\
    sunos-sparcv9,\
    sunos-x86,\
    sunos-x86-64,\
    win32,\
    win32-aarch64,\
    win32-x86,\
    win32-x86-64\
    }

    makeWrapper $out/portfolio/PortfolioPerformance $out/bin/portfolio \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --prefix PATH : ${openjdk21}/bin

    # Create desktop item
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
    mkdir -p $out/share/pixmaps
    ln -s $out/portfolio/icon.xpm $out/share/pixmaps/portfolio.xpm

    runHook postInstall
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
