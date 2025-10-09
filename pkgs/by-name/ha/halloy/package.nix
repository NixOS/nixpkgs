{
  lib,
  stdenv,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  libxkbcommon,
  makeWrapper,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  vulkan-loader,
  wayland,
  xorg,
  alsa-lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "halloy";
  version = "2025.9";

  src = fetchFromGitHub {
    owner = "squidowl";
    repo = "halloy";
    tag = version;
    hash = "sha256-yjia9tNNaXCTQFe8xfUeBYVHhW214AaOeCLFjAG703E=";
  };

  cargoHash = "sha256-GmcRm6/dvY3stjV2ON8NVlVWZ5m0LXa9Kv0gqycbRoY=";

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libxkbcommon
    vulkan-loader
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libxcb
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "org.squidowl.halloy";
      desktopName = "Halloy";
      comment = "IRC client written in Rust";
      icon = "org.squidowl.halloy";
      exec = pname;
      terminal = false;
      mimeTypes = [
        "x-scheme-handler/irc"
        "x-scheme-handler/ircs"
        "x-scheme-handler/halloy"
      ];
      categories = [
        "Network"
        "IRCClient"
      ];
      keywords = [
        "IM"
        "Chat"
      ];
      startupWMClass = "org.squidowl.halloy";
    })
  ];

  postFixup = lib.optional stdenv.hostPlatform.isLinux (
    let
      rpathWayland = lib.makeLibraryPath [
        wayland
        vulkan-loader
        libxkbcommon
      ];
    in
    ''
      rpath=$(patchelf --print-rpath $out/bin/halloy)
      patchelf --set-rpath "$rpath:${rpathWayland}" $out/bin/halloy
    ''
  );

  postInstall = ''
    install -Dm644 assets/linux/icons/hicolor/128x128/apps/org.squidowl.halloy.png \
      $out/share/icons/hicolor/128x128/apps/org.squidowl.halloy.png
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    APP_DIR="$out/Applications/Halloy.app/Contents"

    mkdir -p "$APP_DIR/MacOS"
    cp -r ${src}/assets/macos/Halloy.app/Contents/* "$APP_DIR"

    substituteInPlace "$APP_DIR/Info.plist" \
      --replace-fail "{{ VERSION }}" "${version}" \
      --replace-fail "{{ BUILD }}" "${version}-nixpkgs"

    makeWrapper "$out/bin/halloy" "$APP_DIR/MacOS/halloy"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "IRC application";
    homepage = "https://github.com/squidowl/halloy";
    changelog = "https://github.com/squidowl/halloy/blob/${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      fab
      iivusly
      ivyfanchiang
    ];
    mainProgram = "halloy";
  };
}
