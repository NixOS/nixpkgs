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
}:

python3Packages.buildPythonApplication rec {
  pname = "exhibit";
  version = "1.2.0";
  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "Nokse22";
    repo = "Exhibit";
    rev = "v${version}";
    hash = "sha256-yNS6q7XbWda2+so9QRS/c4uYaVPo7b4JCite5nzc3Eo=";
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

  dependencies = with python3Packages; [
    pygobject3
    f3d
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "3D model viewer for the GNOME desktop powered by f3d";
    homepage = "https://github.com/Nokse22/Exhibit";
    license = with lib.licenses; [
      gpl3Plus
      cc0
    ];
    mainProgram = "exhibit";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
