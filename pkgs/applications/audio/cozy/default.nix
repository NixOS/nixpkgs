{ lib, fetchFromGitHub
, ninja
, meson
, pkg-config
, wrapGAppsHook
, appstream-glib
, desktop-file-utils
, gtk3
, gst_all_1
, gobject-introspection
, libhandy
, libdazzle
, python3Packages
, cairo
, gettext
, gnome
, pantheon
}:

python3Packages.buildPythonApplication rec {

  format = "other"; # no setup.py

  pname = "cozy";
  version = "1.1.2";

  # Temporary fix
  # See https://github.com/NixOS/nixpkgs/issues/57029
  # and https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  src = fetchFromGitHub {
    owner = "geigi";
    repo = pname;
    rev = version;
    sha256 = "sha256-QENn8mFMk06/Uj8QJo0mJQ7frJNcv5RVNJwDB+H/LkI=";
  };

  nativeBuildInputs = [
    meson ninja pkg-config
    wrapGAppsHook
    appstream-glib
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    cairo
    gettext
    gnome.adwaita-icon-theme
    libdazzle
    libhandy
    pantheon.granite
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-good
    gst-plugins-ugly
    gst-plugins-base
    gst-plugins-bad
  ]);

  propagatedBuildInputs = with python3Packages; [
    apsw
    cairo
    dbus-python
    distro
    gst-python
    magic
    mutagen
    packaging
    peewee
    pygobject3
    pytz
    requests
  ];

  postPatch = ''
    patchShebangs meson/*.py
  '';

  postInstall = ''
    ln -s $out/bin/com.github.geigi.cozy $out/bin/cozy
  '';

  meta = with lib; {
    description = "A modern audio book player for Linux using GTK 3";
    homepage = "https://cozy.geigi.de/";
    maintainers = [ maintainers.makefu ];
    license = licenses.gpl3;
  };
}
