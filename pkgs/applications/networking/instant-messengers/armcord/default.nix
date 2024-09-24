{ lib
, stdenv
, fetchFromGitHub
, pnpm
, nodejs
, electron_31
, makeWrapper
, copyDesktopItems
, makeDesktopItem
}:
stdenv.mkDerivation rec {
  pname = "armcord";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "ArmCord";
    repo = "ArmCord";
    rev = "v${version}";
    hash = "sha256-rCcjanmr4s9Nc5QB3Rb5ptKF/Ge8PSZt0WvgIul3RGs=";
  };

  nativeBuildInputs = [ pnpm.configHook nodejs makeWrapper copyDesktopItems ];

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-ZfErOj03NdkviNXV4bvZC8uPOk29RhgmSez/Qvw1sGo=";
  };

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  buildPhase = ''
    runHook preBuild

    pnpm build

    npm exec electron-builder -- \
      --dir \
      -c.electronDist="${electron_31.dist}" \
      -c.electronVersion="${electron_31.version}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/armcord"
    cp -r ./dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/armcord"

    install -Dm644 "build/icon.png" "$out/share/icons/hicolor/256x256/apps/armcord.png"

    makeShellWrapper "${lib.getExe electron_31}" "$out/bin/armcord" \
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
