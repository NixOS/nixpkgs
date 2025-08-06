{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "igs-client";
  version = "0-unstable-2025-07-14";

  src = fetchFromGitHub {
    owner = "maksimKorzh";
    repo = "igs-client";
    rev = "95184ef254bca25ba0a91979bf4bc75662eb92bc";
    hash = "sha256-etmNVa5v9WGJrZ/1/0YGsXYWeqrtOIlxQSgYpxoIVGA=";
  };

  npmDepsHash = "sha256-6nIisCHgbCNLAokFWNLORc7AviQrJ1wwvuLIN8jZ2GU=";

  nativeBuildInputs = [
    copyDesktopItems
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/igs-client
    cp -r ./* $out/share/igs-client

    install -Dm644 $src/assets/pandanet.png $out/share/icons/hicolor/32x32/apps/igs-client.png

    makeWrapper ${lib.getExe electron} $out/bin/igs-client \
      --add-flags $out/share/igs-client \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "IGS-Client";
      type = "Application";
      desktopName = "IGS-Client";
      genericName = "IGS-Client";
      comment = "IGS Pandanet Go Client";
      icon = "igs-client";
      exec = "igs-client";
      categories = [
        "Game"
        "BoardGame"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "IGS Pandanet Go Client GUI";
    homepage = "https://github.com/maksimKorzh/igs-client";
    license = lib.licenses.wtfpl; # See https://github.com/maksimKorzh/igs-client/issues/1#issuecomment-3166941873
    maintainers = with lib.maintainers; [
      dvn0
    ];
    mainProgram = "igs-client";
  };
})
