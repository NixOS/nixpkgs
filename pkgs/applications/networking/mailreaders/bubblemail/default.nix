{ lib
, fetchFromGitLab
, gettext
, gtk3
, python3Packages
, gdk-pixbuf
, libnotify
, gst_all_1
, libsecret
, wrapGAppsHook3
, gsettings-desktop-schemas
, gnome-online-accounts
, glib
, gobject-introspection
, folks
, bash
}:

python3Packages.buildPythonApplication rec {
  pname = "bubblemail";
  version = "1.4";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "razer";
    repo = "bubblemail";
    rev = "v${version}";
    sha256 = "sha256-MPl4pXvdhwCFWTepn/Mxp8ZMs+HCzXC59qdKZp3mHdw=";
  };

  buildInputs = [
    gtk3
    gdk-pixbuf
    glib
    libnotify
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    libsecret
    gnome-online-accounts
    folks
    bash
  ];

  nativeBuildInputs = [
    gettext
    wrapGAppsHook3
    python3Packages.pillow
    # For setup-hook
    gobject-introspection
  ];

  propagatedBuildInputs = with python3Packages; [
    gsettings-desktop-schemas
    pygobject3
    dbus-python
    pyxdg
  ];

  # See https://nixos.org/nixpkgs/manual/#ssec-gnome-common-issues-double-wrapped
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Extensible mail notification service";
    homepage = "http://bubblemail.free.fr/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ doronbehar ];
  };
}
