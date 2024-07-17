{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  libxkbcommon,
  makeWrapper,
  openssl,
  pkg-config,
  rustPlatform,
  vulkan-loader,
  wayland,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "halloy";
  version = "2024.8";

  src = fetchFromGitHub {
    owner = "squidowl";
    repo = "halloy";
    rev = "refs/tags/${version}";
    hash = "sha256-OxxXjenZjP+3KrkxyXYxOXRFmrYm3deeiCuGrhpnF2I=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "dpi-0.1.1" = "sha256-25sOvEBhlIaekTeWvy3UhjPI1xrJbOQvw/OkTg12kQY=";
      "glyphon-0.5.0" = "sha256-+z2my51aUeK9txLZKVAyQcWJ6f2YDY1mjxfc8Xsqi8E=";
      "iced-0.13.0-dev" = "sha256-eHlauEZibbuqK5mdkNP6gsy1z9qxqEDn/xfFw7W5TcY=";
    };
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    pkg-config
  ];

  buildInputs =
    [
      libxkbcommon
      openssl
      vulkan-loader
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.CoreGraphics
      darwin.apple_sdk.frameworks.Cocoa
      darwin.apple_sdk.frameworks.Foundation
      darwin.apple_sdk.frameworks.Metal
      darwin.apple_sdk.frameworks.QuartzCore
      darwin.apple_sdk.frameworks.Security
    ]
    ++ lib.optionals stdenv.isLinux [ wayland ];

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

  postFixup = lib.optional stdenv.isLinux (
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

  postInstall =
    ''
      install -Dm644 assets/linux/icons/hicolor/128x128/apps/org.squidowl.halloy.png \
        $out/share/icons/hicolor/128x128/apps/org.squidowl.halloy.png
    ''
    + lib.optionalString stdenv.isDarwin ''
      APP_DIR="$out/Applications/Halloy.app/Contents"

      mkdir -p "$APP_DIR/MacOS"
      cp -r ${src}/assets/macos/Halloy.app/Contents/* "$APP_DIR"

      substituteInPlace "$APP_DIR/Info.plist" \
        --replace-fail "{{ VERSION }}" "${version}" \
        --replace-fail "{{ BUILD }}" "${version}-nixpkgs"

      makeWrapper "$out/bin/halloy" "$APP_DIR/MacOS/halloy"
    '';

  meta = with lib; {
    description = "IRC application";
    homepage = "https://github.com/squidowl/halloy";
    changelog = "https://github.com/squidowl/halloy/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      fab
      iivusly
    ];
    mainProgram = "halloy";
  };
}
