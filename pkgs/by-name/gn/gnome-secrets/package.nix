{
  lib,
  meson,
  ninja,
  pkg-config,
  gettext,
  fetchFromGitLab,
  python3Packages,
  wrapGAppsHook4,
  gtk4,
  glib,
  gdk-pixbuf,
  gobject-introspection,
  desktop-file-utils,
  appstream-glib,
  libadwaita,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "gnome-secrets";
  version = "11.1.1";
  pyproject = false;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "secrets";
    tag = version;
    hash = "sha256-w2sOSHMfnB6JxSzQbZAmaeRKY3ywF7hyfiIsjn8KEtI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
    appstream-glib
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    glib
    gdk-pixbuf
    libadwaita
  ];

  dependencies = with python3Packages; [
    pygobject3
    construct
    pykcs11
    pykeepass
    pyotp
    validators
    yubico
    zxcvbn-rs-py
  ];

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Password manager for GNOME which makes use of the KeePass v.4 format";
    homepage = "https://gitlab.gnome.org/World/secrets";
    changelog = "https://gitlab.gnome.org/World/secrets/-/releases/${version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mvnetbiz ];
    teams = [ lib.teams.gnome-circle ];
    mainProgram = "secrets";
  };
}
