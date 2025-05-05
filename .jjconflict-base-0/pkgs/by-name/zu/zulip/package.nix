{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  python3,
  electron_35,
  makeDesktopItem,
  makeShellWrapper,
  copyDesktopItems,
}:

buildNpmPackage rec {
  pname = "zulip";
  version = "5.12.0";

  src = fetchFromGitHub {
    owner = "zulip";
    repo = "zulip-desktop";
    tag = "v${version}";
    hash = "sha256-YDb69tJCR58DARssnZgdVxtRpR8vHsawCTv7kQ56y+8=";
  };

  npmDepsHash = "sha256-MKKN6prUdWaHm27GybdbswDMNJH0xVffXsT2ZwroOHI=";

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  nativeBuildInputs = [
    makeShellWrapper
    copyDesktopItems
    (python3.withPackages (ps: with ps; [ distutils ]))
  ];

  dontNpmBuild = true;
  buildPhase = ''
    runHook preBuild

    npm run pack -- \
      -c.electronDist=${electron_35}/libexec/electron \
      -c.electronVersion=${electron_35.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/zulip"
    cp -r dist/*-unpacked/resources/app.asar* "$out/share/lib/zulip/"

    install -m 444 -D app/resources/zulip.png $out/share/icons/hicolor/512x512/apps/zulip.png

    makeShellWrapper '${lib.getExe electron_35}' "$out/bin/zulip" \
      --add-flags "$out/share/lib/zulip/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-wayland-ime=true}}" \
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
      categories = [
        "Chat"
        "Network"
        "InstantMessaging"
      ];
      startupWMClass = "Zulip";
      terminal = false;
    })
  ];

  meta = with lib; {
    description = "Desktop client for Zulip Chat";
    homepage = "https://zulip.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk ];
    platforms = lib.platforms.linux;
    mainProgram = "zulip";
  };
}
