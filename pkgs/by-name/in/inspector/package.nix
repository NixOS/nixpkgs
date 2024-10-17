{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  util-linux,
  pciutils,
  usbutils,
  coreutils,
}:

python3Packages.buildPythonApplication rec {
  pname = "inspector";
  version = "0.2.0";
  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "Nokse22";
    repo = "inspector";
    rev = "v${version}";
    hash = "sha256-tjQCF2Tyv7/NWgrwHu+JPpnLECfDmQS77EVLBt+cRTs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [ libadwaita ];

  dependencies = with python3Packages; [ pygobject3 ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      ''${gappsWrapperArgs[@]}
      --prefix PATH : ${
        lib.makeBinPath [
          util-linux # lscpu lsmem lsblk
          pciutils # lspci
          usbutils # lsusb
          coreutils # uname
        ]
      }
    )
  '';

  meta = {
    description = "Libadwaita wrapper for various cli commands giving information about your system";
    homepage = "https://github.com/Nokse22/inspector";
    license = with lib.licenses; [ gpl3Plus cc0 ];
    mainProgram = "inspector";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
