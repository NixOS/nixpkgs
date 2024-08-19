{ lib
, stdenv
, fetchFromGitHub
, pnpm
, nodejs
, electron_30
, makeWrapper
, copyDesktopItems
, makeDesktopItem
}:
stdenv.mkDerivation rec {
  pname = "armcord";
  version = "3.2.8";

  src = fetchFromGitHub {
    owner = "ArmCord";
    repo = "ArmCord";
    rev = "v${version}";
    hash = "sha256-H/Y3xA7gE24UsUkrxmrRFSvs16qZCVxli9vdnt7ihi8=";
  };

  nativeBuildInputs = [ pnpm.configHook nodejs makeWrapper copyDesktopItems ];

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-hYp1XbWQL5NbIzzUSnZ7y7V+vYQmymRNo+EiSjn5d9E=";
  };

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  buildPhase = ''
    runHook preBuild

    pnpm build

    npm exec electron-builder -- \
      --dir \
      -c.electronDist="${electron_30}/libexec/electron" \
      -c.electronVersion="${electron_30.version}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/armcord"
    cp -r ./dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/armcord"

    install -Dm644 "build/icon.png" "$out/share/icons/hicolor/256x256/apps/armcord.png"

    makeShellWrapper "${lib.getExe electron_30}" "$out/bin/armcord" \
      --add-flags "$out/share/lib/armcord/resources/app.asar" \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "armcord";
      desktopName = "ArmCord";
      exec = "armcord %U";
      icon = "armcord";
      comment = meta.description;
      categories = [ "Network" ];
      startupWMClass = "ArmCord";
      terminal = false;
    })
  ];

  meta = with lib; {
    description = "Lightweight, alternative desktop client for Discord";
    homepage = "https://armcord.app";
    downloadPage = "https://github.com/ArmCord/ArmCord";
    license = licenses.osl3;
    maintainers = with maintainers; [ wrmilling water-sucks ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "armcord";
  };
}
