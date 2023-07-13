{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, makeDesktopItem
, copyDesktopItems
, atk
, blisp
, bzip2
, cairo
, dfu-util
, gdk-pixbuf
, glib
, gtk3
, libusb1
, libxkbcommon
, openssl
, pango
, udev
, stdenv
, darwin
, wayland
}:

rustPlatform.buildRustPackage rec {
  pname = "pineflash";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "Spagett1";
    repo = "PineFlash";
    rev = version;
    hash = "sha256-4izfxApaCLbetZmMMKZIAknb+88B7z2WO+sBafehKHI=";
    fetchSubmodules = true;
  };

  desktopItems = [(makeDesktopItem {
    name = pname;
    exec = "pineflash";
    desktopName = "PineFlash";
    comment = meta.description;
    categories = [ "Utility" ];
  })];

  cargoHash = "sha256-VtUq/scRnx52ibqvUIqvaloaQpZyyXUlJYd2UIKQTjg=";

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    atk
    bzip2
    blisp
    cairo
    dfu-util
    gdk-pixbuf
    glib
    gtk3
    libusb1
    libxkbcommon
    openssl
    pango
    udev
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreGraphics
    darwin.apple_sdk.frameworks.Foundation
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ] ++ lib.optionals stdenv.isLinux [
    wayland
  ];

  postPatch = ''
    # Linux
    substituteInPlace src/submodules/flash.rs \
      --replace 'dfupath = "dfu-util";' 'dfupath = "${dfu-util}/bin/dfu-util";' \
      --replace 'blisppath = "blisp";' 'blisppath = "${blisp}/bin/blisp";'
    # Darwin
    substituteInPlace src/submodules/flash.rs \
        --replace 'Command::new("dfu-util")' 'Command::new("${dfu-util}/bin/dfu-util")' \
        --replace 'Command::new("blisp")' 'Command::new("${blisp}/bin/blisp")'
  '';

  meta = with lib; {
    description = "A tool to flash ironos to the pinecil soldering iron and possibly other pine64 devices in the future";
    homepage = "https://github.com/Spagett1/PineFlash";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ janik ];
  };
}
