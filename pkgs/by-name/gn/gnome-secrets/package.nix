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
}:

python3Packages.buildPythonApplication rec {
  pname = "gnome-secrets";
  version = "10.3";
  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "secrets";
    rev = version;
    hash = "sha256-UcTLngBVp5L8Y1LmBxoxPuH5Zag2YfHA2Y+ByPBkh8A=";
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

  propagatedBuildInputs = with python3Packages; [
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

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Password manager for GNOME which makes use of the KeePass v.4 format";
    homepage = "https://gitlab.gnome.org/World/secrets";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mvnetbiz ];
    mainProgram = "secrets";
  };
}
