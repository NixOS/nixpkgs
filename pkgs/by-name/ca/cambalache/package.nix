{
  lib,
  fetchFromGitLab,
  python3,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  desktop-file-utils,
  shared-mime-info,
  wrapGAppsHook4,
  glib,
  gtk3,
  gtk4,
  gtksourceview5,
  libadwaita,
  libhandy,
  webkitgtk_4_1,
  webkitgtk_6_0,
  nix-update-script,
  casilda,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cambalache";
  version = "0.94.1";
  pyproject = false;

  # Did not fetch submodule since it is only for tests we don't run.
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jpu";
    repo = "cambalache";
    tag = version;
    hash = "sha256-dX9YiBCBG/ALWX0W1CjvdUlOCQ6UulnQCiYUscRMKWk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection # for setup hook
    desktop-file-utils # for update-desktop-database
    shared-mime-info # for update-mime-database
    wrapGAppsHook4
  ];

  pythonPath = with python3.pkgs; [
    pygobject3
    lxml
  ];

  buildInputs = [
    glib
    gtk3
    gtk4
    gtksourceview5
    webkitgtk_4_1
    webkitgtk_6_0
    # For extra widgets support.
    libadwaita
    libhandy
    casilda
  ];

  # Prevent double wrapping.
  dontWrapGApps = true;

  postPatch = ''
    patchShebangs postinstall.py
  '';

  preFixup = ''
    # Let python wrapper use GNOME flags.
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    # Wrap a helper script in an unusual location.
    wrapPythonProgramsIn "$out/${python3.sitePackages}/cambalache/priv/merengue" "$out $pythonPath"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/jpu/cambalache";
    description = "RAD tool for GTK 4 and 3 with data model first philosophy";
    mainProgram = "cambalache";
    teams = [ lib.teams.gnome ];
    license = with lib.licenses; [
      lgpl21Only # Cambalache
      gpl2Only # tools
    ];
    platforms = lib.platforms.unix;
  };
}
