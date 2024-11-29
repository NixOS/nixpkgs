{ lib
, stdenv
, fetchFromGitHub
, pnpm
, nodejs
, electron_32
, makeWrapper
, copyDesktopItems
, makeDesktopItem
, nix-update-script
}:
stdenv.mkDerivation rec {
  pname = "legcord";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "Legcord";
    repo = "Legcord";
    rev = "v${version}";
    hash = "sha256-1nM0v8cjLcctvRcGHGtbyGxaqonIY8wM9s413NxTo+I=";
  };

  nativeBuildInputs = [ pnpm.configHook nodejs makeWrapper copyDesktopItems ];

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-E1kT3WiCYkLwrfHa11P1Z6e0fVnZSpXEQStr1NPjEJU=";
  };

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  buildPhase = ''
    runHook preBuild

    pnpm build

    npm exec electron-builder -- \
      --dir \
      -c.electronDist="${electron_32.dist}" \
      -c.electronVersion="${electron_32.version}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/legcord"
    cp -r ./dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/legcord"

    install -Dm644 "build/icon.png" "$out/share/icons/hicolor/256x256/apps/legcord.png"

    makeShellWrapper "${lib.getExe electron_32}" "$out/bin/legcord" \
      --add-flags "$out/share/lib/legcord/resources/app.asar" \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "legcord";
      desktopName = "Legcord";
      exec = "legcord %U";
      icon = "legcord";
      comment = meta.description;
      categories = [ "Network" ];
      startupWMClass = "Legcord";
      terminal = false;
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Lightweight, alternative desktop client for Discord";
    homepage = "https://legcord.app";
    downloadPage = "https://github.com/Legcord/Legcord";
    license = licenses.osl3;
    maintainers = with maintainers; [ wrmilling water-sucks ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "legcord";
  };
}
