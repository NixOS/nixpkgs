{ lib
, stdenv
, darwin
, fetchFromGitHub
, copyDesktopItems
, makeDesktopItem
, libxkbcommon
, openssl
, pkg-config
, rustPlatform
, vulkan-loader
, wayland
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "halloy";
  version = "2024.5";

  src = fetchFromGitHub {
    owner = "squidowl";
    repo = "halloy";
    rev = "refs/tags/${version}";
    hash = "sha256-F/yQYLYrq3MZFV6igQe4sQi84ChIKCCPdS5151nD6hs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "iced-0.13.0-dev" = "sha256-8L0AoHPwRUeCiJK/N0NTs1Nl4BX0wbM7SLgundhvra0=";
      "winit-0.29.10" = "sha256-YoXJEvEhMvk3pK5EbXceVFeJEJLL6KTjiw0kBJxgHIE=";
    };
  };

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
  ];

  buildInputs = [
    libxkbcommon
    openssl
    vulkan-loader
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreGraphics
    darwin.apple_sdk.frameworks.Cocoa
    darwin.apple_sdk.frameworks.Foundation
    darwin.apple_sdk.frameworks.Metal
    darwin.apple_sdk.frameworks.QuartzCore
    darwin.apple_sdk.frameworks.Security
  ] ++ lib.optionals stdenv.isLinux [
    wayland
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "org.squidowl.halloy";
      desktopName = "Halloy";
      comment = "IRC client written in Rust";
      icon = "org.squidowl.halloy";
      exec = pname;
      terminal = false;
      mimeTypes = [ "x-scheme-handler/irc" "x-scheme-handler/ircs" ];
      categories = [ "Network" "IRCClient" ];
      keywords = [ "IM" "Chat" ];
      startupWMClass = "org.squidowl.halloy";
    })
  ];

  postFixup = lib.optional stdenv.isLinux (
    let
      rpathWayland = lib.makeLibraryPath [ wayland vulkan-loader libxkbcommon ];
    in
    ''
      rpath=$(patchelf --print-rpath $out/bin/halloy)
      patchelf --set-rpath "$rpath:${rpathWayland}" $out/bin/halloy
    '');

  postInstall = ''
    install -Dm644 assets/linux/icons/hicolor/128x128/apps/org.squidowl.halloy.png \
      $out/share/icons/hicolor/128x128/apps/org.squidowl.halloy.png
  '';

  meta = with lib; {
    description = "IRC application";
    homepage = "https://github.com/squidowl/halloy";
    changelog = "https://github.com/squidowl/halloy/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "halloy";
  };
}
