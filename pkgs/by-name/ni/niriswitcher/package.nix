{
  lib,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsHook4,
  gobject-introspection,
  gtk4-layer-shell,
  libadwaita,
}:

python3Packages.buildPythonPackage rec {
  pname = "niriswitcher";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "isaksamsten";
    repo = "niriswitcher";
    tag = version;
    hash = "sha256-jXnob/CJ3wrqYhbFRu7TnnnCrsKaDazD3t9lZoJVhdQ=";
  };

  build-system = [ python3Packages.hatchling ];

  nativeBuildInputs = [
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = [
    gtk4-layer-shell
    libadwaita
  ];

  dependencies = [ python3Packages.pygobject3 ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      ''${gappsWrapperArgs[@]}
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ gtk4-layer-shell ]}
    )
  '';

  meta = {
    description = "Application switcher for niri";
    homepage = "https://github.com/isaksamsten/niriswitcher";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bokicoder ];
    mainProgram = "niriswitcher";
    platforms = lib.platforms.linux;
  };
}
