{ lib, stdenv
, meson
, ninja
, pkg-config
, gettext
, fetchFromGitLab
, python3Packages
, libhandy
, libpwquality
, wrapGAppsHook
, gtk4
, glib
, gdk-pixbuf
, gobject-introspection
, desktop-file-utils
, appstream-glib
, libadwaita }:

python3Packages.buildPythonApplication rec {
  pname = "gnome-secrets";
  version = "6.0";
  format = "other";
  strictDeps = false; # https://github.com/NixOS/nixpkgs/issues/56943

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "secrets";
    rev = version;
    sha256 = "sha256-mtKQSTANkI5CawH4Fe2/rfLmUfobK6pBYgRL7yo/33E=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    wrapGAppsHook
    desktop-file-utils
    appstream-glib
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    glib
    gdk-pixbuf
    libhandy
    libadwaita
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    construct
    pykeepass
    pyotp
  ] ++ [
    libpwquality # using the python bindings
  ];

  meta = with lib; {
    broken = stdenv.hostPlatform.isStatic; # libpwquality doesn't provide bindings when static
    description = "Password manager for GNOME which makes use of the KeePass v.4 format";
    homepage = "https://gitlab.gnome.org/World/secrets";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mvnetbiz ];
  };
}

