{
  lib,
  fetchFromGitLab,
  python3,
  wrapGAppsHook3,
  gobject-introspection,
  gtk3,
  glib,
  gst_all_1,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gnome-keysign";
  version = "1.3.0";
  format = "setuptools";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnome-keysign";
    rev = version;
    hash = "sha256-k77z8Yligzs4rHpPckRGcC5qnCHynHQRjdDkzxwt1Ss=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ]
  ++ (with python3.pkgs; [
    babel
    babelgladeextractor
  ]);

  buildInputs = [
    # TODO: add avahi support
    gtk3
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    (gst_all_1.gst-plugins-bad.override { enableZbar = true; }) # for zbar plug-in
  ];

  propagatedBuildInputs = with python3.pkgs; [
    dbus-python
    future
    gpgme
    magic-wormhole
    pygobject3
    pybluez
    qrcode
    requests
    twisted
  ];

  # bunch of linting
  doCheck = false;

  meta = with lib; {
    description = "GTK/GNOME application to use GnuPG for signing other peoples’ keys";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-keysign";
    license = licenses.gpl3Plus;
    teams = [ teams.gnome ];
    platforms = platforms.linux;
  };
}
