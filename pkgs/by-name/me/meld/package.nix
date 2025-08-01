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

python3.pkgs.buildPythonApplication rec {
  pname = "meld";
  version = "3.23.0";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/meld/${lib.versions.majorMinor version}/meld-${version}.tar.xz";
    hash = "sha256-mDwqQkDgJaIQnHc4GYcQ6dawY8kQsEgzLRRpDPU4wqY=";
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

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "meld";
      versionPolicy = "none"; # should be odd-unstable but we are tracking unstable versions for now
    };
  };

  meta = with lib; {
    description = "Visual diff and merge tool";
    homepage = "https://meld.app/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [
      jtojnar
      mimame
    ];
    mainProgram = "meld";
  };
}
