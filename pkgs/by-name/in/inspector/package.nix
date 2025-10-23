{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  gettext,
  wrapGAppsHook4,
  desktop-file-utils,
  gobject-introspection,
  libadwaita,
  python3Packages,
  iproute2,
  util-linux,
  coreutils,
  usbutils,
  pciutils,
}:

python3Packages.buildPythonApplication rec {
  pname = "inspector";
  version = "0.2.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "Nokse22";
    repo = "inspector";
    rev = "v${version}";
    hash = "sha256-tjQCF2Tyv7/NWgrwHu+JPpnLECfDmQS77EVLBt+cRTs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    wrapGAppsHook4
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    libadwaita
  ];

  dependencies = [
    python3Packages.pygobject3
    iproute2
    util-linux
    coreutils
    usbutils
    pciutils
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/Nokse22/inspector";
    description = "Gtk4 Libadwaita wrapper for various system info cli commands";
    license = with lib.licenses; [
      gpl3Plus
      cc0
    ];
    platforms = lib.platforms.linux;
    mainProgram = "inspector";
    maintainers = with lib.maintainers; [ mksafavi ];
  };
}
