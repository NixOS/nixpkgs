{
  lib,
  stdenvNoCC,
  fetchzip,
  fetchFromGitHub,
  butler,
  electron,
  steam-run,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  version = "26.9.0";

  itch-setup = fetchzip {
    url = "https://broth.itch.zone/itch-setup/linux-amd64/1.29.0/archive.zip";
    stripRoot = false;
    hash = "sha256-T4xvso3jJ9XsiG7QTpYdcvcClg2ejbGS4R/+goaHl18=";
  };

  sparseCheckout = "/release/images/itch-icons";
  icons =
    fetchFromGitHub {
      owner = "itchio";
      repo = "itch";
      rev = "v${version}";
      hash = "sha256-zTUCHpyjfPiYDAatkavNlSHekBTHadiHUa3VyLChYKE=";
      sparseCheckout = [ sparseCheckout ];
    }
    + sparseCheckout;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "itch";
  inherit version;

  src = fetchzip {
    url = "https://github.com/itchio/itch/releases/download/v${finalAttrs.version}/itch-v${finalAttrs.version}-linux-amd64.tar.gz";
    stripRoot = false;
    hash = "sha256-SRgaVweNqf/13C948eWncuCn9Cj82hYxDF3AzCaL5E0=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "itch";
      exec = "itch %U";
      tryExec = "itch";
      icon = "itch";
      desktopName = "itch";
      mimeTypes = [
        "x-scheme-handler/itchio"
        "x-scheme-handler/itch"
      ];
      comment = "Install and play itch.io games easily";
      categories = [ "Game" ];
    })
  ];

  # As taken from https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=itch-bin
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/itch/resources/app
    cp -r resources/app "$out/share/itch/resources/"

    install -Dm644 LICENSE -t "$out/share/licenses/$pkgname/"
    install -Dm644 LICENSES.chromium.html -t "$out/share/licenses/$pkgname/"

    for icon in ${icons}/icon*.png
    do
      iconsize="''${icon#${icons}/icon}"
      iconsize="''${iconsize%.png}"
      icondir="$out/share/icons/hicolor/''${iconsize}x''${iconsize}/apps/"
      install -Dm644 "$icon" "$icondir/itch.png"
    done

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${steam-run}/bin/steam-run $out/bin/itch \
      --add-flags ${electron}/bin/electron \
      --add-flags $out/share/itch/resources/app \
      --set BROTH_USE_LOCAL butler,itch-setup \
      --prefix PATH : ${butler}/bin/:${itch-setup}
  '';

  meta = {
    description = "Best way to play itch.io games";
    homepage = "https://github.com/itchio/itch";
    changelog = "https://github.com/itchio/itch/releases/tag/v${version}-canary";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    maintainers = with lib.maintainers; [ pasqui23 ];
    mainProgram = "itch";
  };
})
