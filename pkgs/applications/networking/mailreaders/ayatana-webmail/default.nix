{ lib
, fetchFromGitHub
, gettext
, gtk3
, python3Packages
, gdk-pixbuf
, libnotify
, glib
, gobject-introspection
, wrapGAppsHook
# BTW libappindicator is also supported, but upstream recommends their
# implementation, see:
# https://github.com/AyatanaIndicators/ayatana-webmail/issues/24#issuecomment-1050352862
, libayatana-appindicator
, gsettings-desktop-schemas
, libcanberra-gtk3
}:

python3Packages.buildPythonApplication rec {
  pname = "ayatana-webmail";
  version = "22.12.15";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "ayatana-webmail";
    rev = version;
    hash = "sha256-K2jqCWrY1i1wYdZVpjN/3TcVyWariOQQ4slZf6sEPRU=";
  };
  postConfigure = ''
    # Fix fhs paths
    substituteInPlace \
      ayatanawebmail/accounts.py \
      ayatanawebmail/actions.py \
      ayatanawebmail/dialog.py \
      --replace /usr/share $out/share
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
    wrapGAppsHook
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

  meta = with lib; {
    description = "Webmail notifications and actions for any desktop";
    homepage = "https://github.com/AyatanaIndicators/ayatana-webmail";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ doronbehar ];
  };
}
