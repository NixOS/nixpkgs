{
  lib,
  fetchFromGitHub,
  gettext,
  gtk3,
  python3Packages,
  gdk-pixbuf,
  libnotify,
  glib,
  gobject-introspection,
  wrapGAppsHook3,
  # BTW libappindicator is also supported, but upstream recommends their
  # implementation, see:
  # https://github.com/AyatanaIndicators/ayatana-webmail/issues/24#issuecomment-1050352862
  libayatana-appindicator,
  gsettings-desktop-schemas,
  libcanberra-gtk3,
}:

python3Packages.buildPythonApplication rec {
  pname = "ayatana-webmail";
  version = "24.5.17";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "ayatana-webmail";
    tag = version;
    hash = "sha256-k557FWKGq2MXODVxVzOetC5kkwTNYOoLO8msCOabais=";
  };
  postConfigure = ''
    # Fix fhs paths
    substituteInPlace \
      ayatanawebmail/accounts.py \
      ayatanawebmail/actions.py \
      ayatanawebmail/dialog.py \
      --replace-fail /usr/share $out/share
  '';

  buildInputs = [
    gtk3
    gdk-pixbuf
    glib
    libnotify
    gettext
    libayatana-appindicator
    gsettings-desktop-schemas
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
    glib # For compiling gsettings-schemas
  ];

  propagatedBuildInputs = with python3Packages; [
    urllib3
    babel
    psutil
    secretstorage
    polib
    pygobject3
    dbus-python
  ];

  # No tests, and they cause a failure
  doCheck = false;

  postInstall = ''
    # Fix fhs paths
    mv $out/${python3Packages.python.sitePackages}/etc $out
    mv $out/${python3Packages.python.sitePackages}/usr/{bin,share} $out/
    rmdir $out/${python3Packages.python.sitePackages}/usr
    # Compile gsettings desktop schemas
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  # See https://nixos.org/nixpkgs/manual/#ssec-gnome-common-issues-double-wrapped
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    makeWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ libcanberra-gtk3 ]})
  '';

  meta = {
    description = "Webmail notifications and actions for any desktop";
    homepage = "https://github.com/AyatanaIndicators/ayatana-webmail";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
