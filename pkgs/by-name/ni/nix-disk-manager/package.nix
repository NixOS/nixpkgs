{
  lib,
  fetchFromGithub,
  fetchurl,
  flutter,
  dart,
  zlib,
  gtk3,
  pkg-config,
  libtool,
  libGL,
  libX11,
  nix-update-script,
}:

flutter.buildFlutterApplication rec {
  pname = "nix-disk-manager";
  version = "1.4.1";

  src = fetchFromGithub {
    owner = "imikado";
    repo = "nix-disk-manager";
    tag = version;
    hash = "sha256-Ao1wTJuyuqKZQMc7sC0/LUxfAPrkf2xs0oLYkHa4Am0=";
  };

  pubspecLock = ./pubspec.lock;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    flutter
    dart
    zlib
    gtk3
    pkg-config
    libtool
    libGL
    libX11
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Disk manager for NixOS";
    homepage = "https://codeberg.org/imikado/nix-disk-manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
    mainProgram = "nix_disk_manager";
  };
}
