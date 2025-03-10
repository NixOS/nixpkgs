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
  version = "1.3.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "imikado";
    repo = "nix-disk-manager";
    tag = version;
    hash = "sha256-hGP6AFDMpFldV05BY0maQnjAK5ci/QYkvCpq1xnHhUc=";
  };

  autoPubspecLock = fetchurl {
    url = "https://codeberg.org/imikado/nix-disk-manager/raw/tag/${version}/pubspec.lock";
    hash = "sha256-yQsFlOXBOXUwlGE9sHJ5MHYKdQM+0l7QXEUoTUrf8XY=";
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
