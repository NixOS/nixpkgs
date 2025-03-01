{
  lib,
  fetchFromGitea,
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
  version = "1.1.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "imikado";
    repo = "nix-disk-manager";
    rev = version;
    hash = "sha256-RXscJvY9SemGZn7Y1LeT4sS+DhpNTINPkuUjspYpa6I=";
  };

  autoPubspecLock = fetchurl {
    url = "https://codeberg.org/imikado/nix-disk-manager/raw/tag/${version}/pubspec.lock";
    hash = "sha256-glBc2dp9BIAae0SI98yaeeyno81rtq3JhIBTvnbUjnU=";
  };

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
