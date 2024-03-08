{ lib
, stdenv
, fetchFromGitHub
, electron_22
, makeWrapper
, makeDesktopItem
, copyDesktopItems
}:

stdenv.mkDerivation rec {
  pname = "passky-desktop";
  version = "8.1.1";

  src = fetchFromGitHub {
    owner = "Rabbit-Company";
    repo = "Passky-Desktop";
    rev = "refs/tags/v${version}";
    sha256 = "1ma8s1bngjdzclcc4m5pcmavk38sidaskmz7dgfnv84y35si18dr";
  };

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/passky
    cp -r "." "$out/share/passky/electron"

    local resolution
    for icon in $out/share/passky/electron/images/icons/icon*.png; do
      resolution=''${icon%".png"}
      resolution=''${resolution##*/icon-}
      mkdir -p "$out/share/icons/hicolor/''${resolution}/apps"
      ln -s "$icon" "$out/share/icons/hicolor/''${resolution}/apps/passky.png"
    done

    mkdir "$out/share/applications"
    makeWrapper ${electron_22}/bin/electron "$out/bin/passky" \
      --add-flags "$out/share/passky/electron/" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    runHook postInstall
  '';

  desktopItems = [
    (
      makeDesktopItem {
        name = "Passky";
        type = "Application";
        desktopName = "passky";
        comment = "Simple, modern, open source and secure password manager.";
        icon = "passky";
        exec = "passky %U";
        categories = [ "Utility" ];
        startupWMClass = "Passky";
      }
    )
  ];

  meta = with lib; {
    description = "A simple, modern, lightweight, open source and secure password manager";
    homepage = "https://passky.org";
    downloadPage = "https://github.com/Rabbit-Company/Passky-Desktop/releases";
    changelog = "https://github.com/Rabbit-Company/Passky-Desktop/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ akkesm ];
    mainProgram = "passky";
    platforms = platforms.unix;
  };
}
