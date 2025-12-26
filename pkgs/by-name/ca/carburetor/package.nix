{
  lib,
  fetchFromGitLab,
  fetchpatch2,
  python3Packages,
  appstream,
  desktop-file-utils,
  gobject-introspection,
  pkg-config,
  meson,
  wrapGAppsHook4,
  libadwaita,
  tractor,
}:
let
  # This package should be updated together with pkgs/by-name/tr/tractor/package.nix
  version = "5.1.1";
in
python3Packages.buildPythonApplication {

  pname = "carburetor";
  inherit version;

  pyproject = false;

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "tractor";
    repo = "carburetor";
    tag = version;
    hash = "sha256-mHuD9fxHTmTfEdAsiqTtFVzxXEjD8VIDNDKF2RjcAUg=";
  };

  build-system = [
    meson
    python3Packages.meson-python
  ];

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    gobject-introspection
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [ libadwaita ];

  dependencies = [
    python3Packages.pycountry
    python3Packages.pygobject3
    tractor
  ];

  dontWrapGApps = true;

  preFixup = ''
    substituteInPlace $out/share/applications/io.frama.tractor.carburetor.desktop \
      --replace-fail "Exec=gapplication launch io.frama.tractor.carburetor" "Exec=$out/bin/carburetor"
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    homepage = "https://framagit.org/tractor/carburetor";
    description = "Graphical settings app for Tractor in GTK";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "carburetor";
    maintainers = with lib.maintainers; [ mksafavi ];
  };
}
