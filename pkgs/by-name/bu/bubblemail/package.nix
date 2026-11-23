{
  lib,
  fetchFromGitLab,
  gettext,
  gtk3,
  python3Packages,
  gdk-pixbuf,
  libnotify,
  gstreamer,
  gst-plugins-good,
  gst-plugins-base,
  gst-plugins-bad,
  libsecret,
  wrapGAppsHook3,
  gsettings-desktop-schemas,
  gnome-online-accounts,
  glib,
  gobject-introspection,
  folks,
  bash,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "bubblemail";
  version = "1.9";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "razer";
    repo = "bubblemail";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eXEFBLo7CbLRlnI2nr7qWAdLUKe6PLQJ78Ho8MP9ShY=";
  };

  buildInputs = [
    gtk3
    gdk-pixbuf
    glib
    libnotify
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
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

  build-system = with python3Packages; [
    setuptools
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

  meta = {
    description = "Extensible mail notification service";
    homepage = "http://bubblemail.free.fr/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
