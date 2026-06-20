{
  lib,
  stdenv,
  fetchurl,
  gettext,
  itstool,
  python3,
  meson,
  ninja,
  wrapGAppsHook3,
  libxml2,
  pkg-config,
  desktop-file-utils,
  gobject-introspection,
  gtk3,
  gtksourceview4,
  gnome,
  adwaita-icon-theme,
  gsettings-desktop-schemas,
  desktopToDarwinBundle,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "meld";
  version = "3.23.1";

  pyproject = false;

  src = fetchurl {
    url = "mirror://gnome/sources/meld/${lib.versions.majorMinor finalAttrs.version}/meld-${finalAttrs.version}.tar.xz";
    hash = "sha256-c/gnkkZjx8a0UadMg4UwTZn+qhPIH04KFx2ll8aENXQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    itstool
    libxml2
    pkg-config
    desktop-file-utils
    gobject-introspection
    wrapGAppsHook3
    gtk3 # for gtk-update-icon-cache
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [
    gtk3
    gtksourceview4
    gsettings-desktop-schemas
    adwaita-icon-theme
  ];

  pythonPath = with python3.pkgs; [
    pygobject3
    pycairo
  ];

  postPatch = ''
    patchShebangs meson_shebang_normalisation.py
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "meld";
      versionPolicy = "none"; # should be odd-unstable but we are tracking unstable versions for now
    };
  };

  meta = {
    description = "Visual diff and merge tool";
    homepage = "https://meld.app/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      jtojnar
      mimame
    ];
    mainProgram = "meld";
  };
})
