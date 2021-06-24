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
, python3Packages
, file
, cairo
, gettext
, gnome3
}:

python3Packages.buildPythonApplication rec {

  format = "other"; # no setup.py

  pname = "cozy";
  version = "0.7.2";

  # Temporary fix
  # See https://github.com/NixOS/nixpkgs/issues/57029
  # and https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  src = fetchFromGitHub {
    owner = "geigi";
    repo = pname;
    rev = version;
    sha256 = "0fmbddi4ga0bppwg3rm3yjmf7jgqc6zfslmavnr1pglbzkjhy9fs";
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
    gnome3.adwaita-icon-theme
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-good
    gst-plugins-ugly
    gst-plugins-base
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
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
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
