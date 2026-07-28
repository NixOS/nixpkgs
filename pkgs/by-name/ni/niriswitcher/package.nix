{
  lib,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsHook4,
  gobject-introspection,
  gtk4-layer-shell,
  libadwaita,
  nix-update-script,
}:

python3Packages.buildPythonPackage rec {
  pname = "niriswitcher";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "isaksamsten";
    repo = "niriswitcher";
    tag = version;
    hash = "sha256-qsw2D9Q9ZJYBsRECzT+qoytYMda4uZxX321/YxNWk9o=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Application switcher for niri";
    homepage = "https://github.com/isaksamsten/niriswitcher";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bokicoder ];
    mainProgram = "niriswitcher";
    platforms = lib.platforms.linux;
  };
}
