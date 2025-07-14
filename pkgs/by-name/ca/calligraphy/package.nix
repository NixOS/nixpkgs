{
  lib,
  python3Packages,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "calligraphy";
  version = "1.2.0";
  pyproject = false; # Built with meson

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GeopJr";
    repo = "Calligraphy";
    tag = "v${version}";
    hash = "sha256-KDml96oxnmTygTC+3rZ//wKv7xDSjw37+UHu3a3zuO4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
  ];

  dependencies = with python3Packages; [
    pygobject3
    pyfiglet
  ];

  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GTK tool turning text into ASCII banners";
    homepage = "https://calligraphy.geopjr.dev";
    license = with lib.licenses; [
      gpl3Plus
      # and
      cc0
    ];
    mainProgram = "calligraphy";
    maintainers = with lib.maintainers; [
      aleksana
      awwpotato
    ];
    platforms = lib.platforms.linux;
  };
}
