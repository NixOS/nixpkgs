{ lib
, stdenvNoCC
, fetchzip
, fetchFromGitHub
, butler
, electron
, steam-run
, makeWrapper
, copyDesktopItems
, makeDesktopItem
}:
stdenvNoCC.mkDerivation rec {
  pname = "itch";
  version = "26.1.3";

  # TODO: Using kitch instead of itch, revert when possible
  src = fetchzip {
    url = "https://broth.itch.ovh/kitch/linux-amd64/${version}/archive/default#.zip";
    stripRoot = false;
    hash = "sha256-FHwbzLPMzIpyg6KyYTq6/rSNRH76dytwb9D5f9vNKkU=";
  };

  itch-setup = fetchzip {
    url = "https://broth.itch.ovh/itch-setup/linux-amd64/1.26.0/itch-setup.zip";
    stripRoot = false;
    hash = "sha256-5MP6X33Jfu97o5R1n6Og64Bv4ZMxVM0A8lXeQug+bNA=";
  };

  icons = let sparseCheckout = "/release/images/itch-icons"; in
    fetchFromGitHub {
        owner = "itchio";
        repo = "itch";
        rev = "v${version}-canary";
        hash = "sha256-0AMyDZ5oI7/pSvudoEqXnMZJtpcKVlUSR6YVm+s4xv0=";
        sparseCheckout = [ sparseCheckout ];
      } + sparseCheckout;

  nativeBuildInputs = [ copyDesktopItems makeWrapper ];

  desktopItems = [
    (makeDesktopItem {
      name = "itch";
      exec = "itch %U";
      tryExec = "itch";
      icon = "itch";
      desktopName = "itch";
      mimeTypes = [ "x-scheme-handler/itchio" "x-scheme-handler/itch" ];
      comment = "Install and play itch.io games easily";
      categories = [ "Game" ];
    })
  ];

  # As taken from https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=itch-bin
  installPhase = ''
    runHook preInstall

    # TODO: Remove when the next stable Itch is stabilized
    substituteInPlace ./resources/app/package.json \
      --replace "kitch" "itch"

    mkdir -p $out/bin $out/share/itch/resources/app
    cp -r resources/app "$out/share/itch/resources/"

    install -Dm644 LICENSE -t "$out/share/licenses/$pkgname/"
    install -Dm644 LICENSES.chromium.html -t "$out/share/licenses/$pkgname/"

    for icon in $icons/icon*.png
    do
      iconsize="''${icon#$icons/icon}"
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

  meta = with lib; {
    description = "The best way to play itch.io games";
    homepage = "https://github.com/itchio/itch";
    license = licenses.mit;
    platforms = platforms.linux;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    maintainers = with maintainers; [ pasqui23 ];
    mainProgram = "itch";
  };
}
