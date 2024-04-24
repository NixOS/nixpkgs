{ lib
, stdenv
, autoPatchelfHook
, fetchurl
, glib-networking
, glibc
, gcc-unwrapped
, gtk3
, jre
, libsecret
, makeDesktopItem
, webkitgtk
, wrapGAppsHook
, writeScript
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

  runtimeLibs = lib.makeLibraryPath [ gtk3 webkitgtk ];
in
stdenv.mkDerivation rec {
  pname = "PortfolioPerformance";
  version = "0.68.3";

  src = fetchurl {
    url = "https://github.com/buchen/portfolio/releases/download/${version}/PortfolioPerformance-${version}-linux.gtk.x86_64.tar.gz";
    hash = "sha256-7EQ/gKFflElga5LDwAkjPcqNl6HNtnAzno1ZGPBybJY=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
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
      --prefix PATH : ${jre}/bin

    # Create desktop item
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
    mkdir -p $out/share/pixmaps
    ln -s $out/portfolio/icon.xpm $out/share/pixmaps/portfolio.xpm
  '';

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    version="$(curl -sL "https://api.github.com/repos/buchen/portfolio/tags" | jq '.[0].name' --raw-output)"
    update-source-version portfolio "$version"
  '';

  meta = with lib; {
    description = "A simple tool to calculate the overall performance of an investment portfolio";
    homepage = "https://www.portfolio-performance.info/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.epl10;
    maintainers = with maintainers; [ elohmeier kilianar oyren shawn8901 ];
    mainProgram = "portfolio";
    platforms = [ "x86_64-linux" ];
  };
}
