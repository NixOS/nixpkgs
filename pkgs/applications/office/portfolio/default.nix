{ lib
, stdenv
, maven
, autoPatchelfHook
, fetchFromGitHub
, glib-networking
, glibc
, gcc-unwrapped
, gtk3
, jre
, libsecret
, makeDesktopItem
, webkitgtk
, wrapGAppsHook
, nix-update-script
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
maven.buildMavenPackage rec {
  pname = "PortfolioPerformance";
  version = "0.67.0";

  src = fetchFromGitHub {
    owner = "buchen";
    repo = "portfolio";
    rev = version;
    hash = "sha256-bZCWjJ0+yDu/oGGutebh5ZSaCF3lyn/ghSo73mpM8Po=";
  };

  mvnHash = "sha256-gbb/lhobNlAHggWIiAuPbQMYBak3b8F0mvLNEJ7sVOk=";

  mvnParameters = "--file portfolio-app/pom.xml";

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
    cp -av ./portfolio-product/target/products/name.abuchen.portfolio.product/linux/gtk/${stdenv.targetPlatform.linuxArch}/portfolio/* $out/portfolio/

    makeWrapper $out/portfolio/PortfolioPerformance $out/bin/portfolio \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --prefix PATH : ${jre}/bin

    # Create desktop item
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
    mkdir -p $out/share/pixmaps
    ln -s $out/portfolio/icon.xpm $out/share/pixmaps/portfolio.xpm
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A simple tool to calculate the overall performance of an investment portfolio";
    homepage = "https://www.portfolio-performance.info/";
    license = licenses.epl10;
    maintainers = with maintainers; [ elohmeier kilianar oyren shawn8901 ];
    mainProgram = "portfolio";
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
