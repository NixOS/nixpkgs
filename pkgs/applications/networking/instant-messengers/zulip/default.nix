{ lib
, fetchFromGitHub
, buildNpmPackage
, electron_28
, makeDesktopItem
, copyDesktopItems
}:

buildNpmPackage rec {
  pname = "zulip";
  version = "5.10.5";

  src = fetchFromGitHub {
    owner = "zulip";
    repo = "zulip-desktop";
    rev = "v${version}";
    hash = "sha256-ule9cggAXLqEuTKUmklm7LBiTWzBDKhtkyk123/3Lsc=";
  };

  npmDepsHash = "sha256-kE8WvSUuSu7H4lEgQZtMHmrHM5T5dwICvVCc8Rsu0bA=";

  ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  nativeBuildInputs = [
    copyDesktopItems
  ];

  dontNpmBuild = true;
  buildPhase = ''
    runHook preBuild

    npm run pack -- \
      -c.electronDist=${electron_28}/libexec/electron \
      -c.electronVersion=${electron_28.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/zulip"
    cp -r dist/*-unpacked/resources/app.asar* "$out/share/lib/zulip/"

    install -m 444 -D app/resources/zulip.png $out/share/icons/hicolor/512x512/apps/zulip.png

    makeWrapper '${electron_28}/bin/electron' "$out/bin/zulip" \
      --add-flags "$out/share/lib/zulip/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "zulip";
      exec = "zulip %U";
      icon = "zulip";
      desktopName = "Zulip";
      comment = "Zulip Desktop Client for Linux";
      categories = [ "Chat" "Network" "InstantMessaging" ];
      startupWMClass = "Zulip";
      terminal = false;
    })
  ];

  meta = with lib; {
    description = "Desktop client for Zulip Chat";
    homepage = "https://zulip.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk jonafato ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "zulip";
  };
}
