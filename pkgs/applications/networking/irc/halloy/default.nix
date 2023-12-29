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
  version = "2023.5";

  src = fetchFromGitHub {
    owner = "squidowl";
    repo = "halloy";
    rev = "refs/tags/${version}";
    hash = "sha256-XGNFLfZDDGTT55UAsapUf1B0uSzrNjwSRK+yQSU3wG0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "iced-0.9.0" = "sha256-z/tkUdFXNjxR5Si8dnNrkrvFos0VAqGjnFNSs88D/5w=";
      "winit-0.28.6" = "sha256-szB1LCOPmPqhZNIWbeO8JMfRMcMRr0+Ze0f4uqyR8AE=";
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

  postInstall = ''
    install -Dm644 assets/linux/org.squidowl.halloy.png $out/share/icons/hicolor/128x128/apps/org.squidowl.halloy.png
  '';

  meta = with lib; {
    description = "IRC application";
    homepage = "https://github.com/squidowl/halloy";
    changelog = "https://github.com/squidowl/halloy/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
