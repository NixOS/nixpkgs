{ lib
, stdenv
, fetchFromGitHub
, electron_29
, makeWrapper
, makeDesktopItem
, copyDesktopItems
}:

let
  electron = electron_29;
in
stdenv.mkDerivation rec {
  pname = "passky-desktop";
  version = "8.1.2";

  src = fetchFromGitHub {
    owner = "Rabbit-Company";
    repo = "Passky-Desktop";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-QQ0+qIkDPNCHeWmcF6FkbDrrt/r3fIkNi0dv6XlV1rc=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

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
    makeWrapper ${electron}/bin/electron "$out/bin/passky" \
      --add-flags "$out/share/passky/electron/" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    runHook postInstall
  '';

  desktopItems = [
    (
      makeDesktopItem {
        name = "passky";
        type = "Application";
        desktopName = "Passky";
        comment = "Simple, modern, open source and secure password manager.";
        icon = "passky";
        exec = "passky %U";
        terminal = false;
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
