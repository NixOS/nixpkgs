{ lib
, fetchFromGitLab
, gettext
, gtk3
, python3Packages
, gdk-pixbuf
, libnotify
, gst_all_1
, libsecret
, wrapGAppsHook
, gsettings-desktop-schemas
, gnome-online-accounts
, glib
, gobject-introspection
, folks
}:

python3Packages.buildPythonApplication rec {
  pname = "bubblemail";
  version = "1.3";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "razer";
    repo = "bubblemail";
    rev = "v${version}";
    sha256 = "FEIdEoZBlM28F5kSMoln7KACwetb8hp+qix1P+DIE8k=";
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
  ];

  nativeBuildInputs = [
    gettext
    wrapGAppsHook
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

  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "An extensible mail notification service.";
    homepage = "http://bubblemail.free.fr/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ doronbehar ];
  };
}
