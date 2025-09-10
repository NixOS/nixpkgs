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
  version = "26.1.9";

  itch-setup = fetchzip {
    url = "https://broth.itch.zone/itch-setup/linux-amd64/1.26.0/itch-setup.zip";
    stripRoot = false;
    hash = "sha256-5MP6X33Jfu97o5R1n6Og64Bv4ZMxVM0A8lXeQug+bNA=";
  };

  sparseCheckout = "/release/images/itch-icons";
  icons =
    fetchFromGitHub {
      owner = "itchio";
      repo = "itch";
      rev = "v${version}";
      hash = "sha256-jugg+hdP0y0OkFhdQuEI9neWDuNf2p3+DQuwxe09Zck=";
      sparseCheckout = [ sparseCheckout ];
    }
    + sparseCheckout;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "itch";
  inherit version;

  src = fetchzip {
    url = "https://broth.itch.zone/itch/linux-amd64/${finalAttrs.version}/archive/default#.zip";
    stripRoot = false;
    hash = "sha256-4k6afBgOKGs7rzXAtIBpmuQeeT/Va8/0bZgNYjuJhgI=";
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
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set BROTH_USE_LOCAL butler,itch-setup \
      --prefix PATH : ${butler}/bin/:${itch-setup}
  '';

  meta = {
    description = "Best way to play itch.io games";
    homepage = "https://github.com/itchio/itch";
    changelog = "https://github.com/itchio/itch/releases/tag/v${version}-canary";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    maintainers = with lib.maintainers; [ pasqui23 ];
    mainProgram = "itch";
  };
})
