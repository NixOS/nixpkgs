{
  lib,
  python3,
  fetchFromGitLab,
  desktop-file-utils,
  gobject-introspection,
  gtk4,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "powersupply";
  version = "0.10.2";

  pyproject = false;

  src = fetchFromGitLab {
    domain = "gitlab.postmarketos.org";
    owner = "postmarketOS";
    repo = "powersupply";
    rev = finalAttrs.version;
    hash = "sha256-i0AZfxYWj8ct2jiXl2GnCGMU3xBSRRny4H0G/5Qs14Y=";
  };

  postPatch = ''
    substituteInPlace build-aux/meson/postinstall.py \
      --replace 'gtk-update-icon-cache' 'gtk4-update-icon-cache'
  '';

  nativeBuildInputs = [
    desktop-file-utils
    gtk4 # for gtk4-update-icon-cache
    gobject-introspection # Without this, launching the app on aarch64-linux results in ValueError: Namespace Gtk not available
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  dependencies = with python3.pkgs; [
    pygobject3
  ];

  strictDeps = true;

  meta = {
    description = "Graphical app to display power status of mobile Linux platforms";
    homepage = "https://gitlab.postmarketos.org/postmarketOS/powersupply";
    license = lib.licenses.mit;
    mainProgram = "powersupply";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Luflosi ];
  };
})
