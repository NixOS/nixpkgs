{ stdenv, fetchFromGitHub
, ninja
, boost
, meson
, pkgconfig
, wrapGAppsHook
, appstream-glib
, desktop-file-utils
, gtk3
, gst_all_1
, gobject-introspection
, python3Packages
, file
, cairo
, sqlite
, gettext
, gnome3
}:

python3Packages.buildPythonApplication rec {

  format = "other"; # no setup.py

  name = "cozy-${version}";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "geigi";
    repo = "cozy";
    rev = version;
    sha256 = "0xs6vzvmx0nvybpjqlrngggv2x8b2ky073slh760iirs1p0dclbc";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig
    wrapGAppsHook
    appstream-glib
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    cairo
    gettext
    gnome3.defaultIconTheme
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-good
    gst-plugins-ugly
    gst-plugins-base
  ]);

  propagatedBuildInputs = with python3Packages; [
    gst-python
    pygobject3
    dbus-python
    mutagen
    peewee
    magic
  ];

  postPatch = ''
    chmod +x data/meson_post_install.py
    patchShebangs data/meson_post_install.py
    substituteInPlace cozy/magic/magic.py --replace "ctypes.util.find_library('magic')" "'${file}/lib/libmagic${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  postInstall = ''
    ln -s $out/bin/com.github.geigi.cozy $out/bin/cozy
  '';

  meta = with stdenv.lib; {
    description = ''
       A modern audio book player for Linux using GTK+ 3
    '';
    homepage = https://cozy.geigi.de/;
    maintainers = [ maintainers.makefu ];
    license = licenses.gpl3;
  };
}
