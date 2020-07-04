{ stdenv
, fetchFromGitHub
, gettext
, gtk3
, pythonPackages
, gdk-pixbuf
, libnotify
, gst_all_1
, libsecret
, wrapGAppsHook
, gsettings-desktop-schemas
, glib
, gobject-introspection
}:

pythonPackages.buildPythonApplication rec {
  pname = "mailnag";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "pulb";
    repo = "mailnag";
    rev = "v${version}";
    sha256 = "0q97v9i96br22z3h6r2mz79i68ib8m8x42yxky78szfrf8j60i30";
  };
  preFixup = ''
    substituteInPlace $out/${pythonPackages.python.sitePackages}/Mailnag/common/dist_cfg.py \
      --replace "/usr/" $out/
    for desktop_file in $out/share/applications/*.desktop; do
      substituteInPlace "$desktop_file" \
      --replace "/usr/bin" $out/bin
    done
  '';

  buildInputs = [
    gtk3
    gdk-pixbuf
    glib
    libnotify
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gobject-introspection
    libsecret
  ];

  nativeBuildInputs = [
    gettext
    wrapGAppsHook
  ];

  propagatedBuildInputs = with pythonPackages; [
    gsettings-desktop-schemas
    pygobject3
    dbus-python
    pyxdg
  ];

  meta = with stdenv.lib; {
    description = "An extensible mail notification daemon";
    homepage = "https://github.com/pulb/mailnag";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ doronbehar ];
  };
}
