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
  version = "5.0.0";
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
    hash = "sha256-Z67bqjogPz5sz6JwM68z1jsaqvRBAOMDeBLcyLo+QLY=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://framagit.org/tractor/carburetor/-/commit/620b70288942497abc20ad26c043b593f66e9e3b.diff";
      hash = "sha256-oFKLjvu+fwgyU4FIUb2K8jwXOP34P3pEazOhofwveJw=";
    })
  ];

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
