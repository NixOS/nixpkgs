{ lib, stdenv
, meson
, ninja
, pkg-config
, gettext
, fetchFromGitLab
, python3Packages
, wrapGAppsHook4
, gtk4
, glib
, gdk-pixbuf
, gobject-introspection
, desktop-file-utils
, appstream-glib
, libadwaita }:

python3Packages.buildPythonApplication rec {
  pname = "gnome-secrets";
  version = "6.5";
  format = "other";
  strictDeps = false; # https://github.com/NixOS/nixpkgs/issues/56943

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "secrets";
    rev = version;
    sha256 = "sha256-Hy2W7cvvzVcKtd/KzTn81awoolnfM3ST0Nm70YBLTYY=";
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
    python3Packages.libpwquality.dev # Use python-enabled libpwquality
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    construct
    pykeepass
    pyotp
    libpwquality
  ];

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    broken = stdenv.hostPlatform.isStatic; # libpwquality doesn't provide bindings when static
    description = "Password manager for GNOME which makes use of the KeePass v.4 format";
    homepage = "https://gitlab.gnome.org/World/secrets";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mvnetbiz ];
  };
}
