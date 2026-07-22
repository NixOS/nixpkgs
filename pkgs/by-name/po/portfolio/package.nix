{
  autoPatchelfHook,
  copyDesktopItems,
  fetchurl,
  glib,
  glib-networking,
  gtk3,
  jdk21_headless,
  jre_minimal,
  lib,
  libsecret,
  makeDesktopItem,
  makeWrapper,
  stdenvNoCC,
  webkitgtk_4_1,
  wrapGAppsHook3,
  imagemagick,
  gitUpdater,
}:
let
  jre = jre_minimal.override {
    jdk = jdk21_headless;
    modules = [
      "java.base"
      "java.desktop"
      "jdk.localedata"
      "java.management"
      "java.naming"
      "java.net.http"
      "java.security.jgss"
      "java.sql"
      "java.xml"
      "jdk.crypto.ec"
      "jdk.net"
      "jdk.httpserver"
      "jdk.unsupported"
      "jdk.xml.dom"
    ];
  };

  runtimeDeps = [
    glib
    glib-networking
    gtk3
    libsecret
    webkitgtk_4_1
  ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "PortfolioPerformance";
  version = "0.84.2";

  src = fetchurl {
    url = "https://github.com/buchen/portfolio/releases/download/${finalAttrs.version}/PortfolioPerformance-${finalAttrs.version}-linux.gtk.x86_64.tar.gz";
    hash = "sha256-boeXTZ0I0uGGuSSU/qVwxwb4dNs2NDL4ip4BsZhVOis=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    imagemagick
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = runtimeDeps;

  dontWrapGApps = true;

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

    # Eclipse source bundles are not needed at runtime.
    rm -f $out/portfolio/plugins/*.source_*.jar
    rm -rf $out/portfolio/configuration/org.eclipse.equinox.source

    mkdir -p $out/share/icons/hicolor/256x256/apps
    magick $out/portfolio/icon.xpm $out/share/icons/hicolor/256x256/apps/portfolio.png

    runHook postInstall
  '';

  postFixup = ''
    mkdir -p $out/bin
    makeWrapper $out/portfolio/PortfolioPerformance $out/bin/portfolio \
      "''${gappsWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDeps}" \
      --prefix PATH : ${lib.makeBinPath [ jre ]} \
      --set JAVA_HOME "${jre}"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Portfolio";
      exec = "portfolio";
      icon = "portfolio";
      comment = "Calculate Investment Portfolio Performance";
      desktopName = "Portfolio Performance";
      categories = [ "Office" ];
      startupWMClass = "Portfolio Performance";
    })
  ];

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
