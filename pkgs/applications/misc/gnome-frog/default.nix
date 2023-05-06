{ stdenv
, lib
, fetchFromGitHub
, python3Packages
, wrapGAppsHook4
, gtk4
, meson
, ninja
, pkg-config
, appstream-glib
, desktop-file-utils
, glib
, gobject-introspection
, libnotify
, libadwaita
, libportal
, gettext
, librsvg
, tesseract5
, zbar
}:

python3Packages.buildPythonApplication rec {
  pname = "gnome-frog";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "TenderOwl";
    repo = "Frog";
    rev = "refs/tags/${version}";
    sha256 = "sha256-ErDHrdD9UZxOIGwgN5eakY6vhNvE6D9SoRYXZhzmYX4=";
  };

  format = "other";

  patches = [ ./update-compatible-with-non-flatpak-env.patch ];
  postPatch = ''
    chmod +x ./build-aux/meson/postinstall.py
    patchShebangs ./build-aux/meson/postinstall.py
    substituteInPlace ./build-aux/meson/postinstall.py \
      --replace "gtk-update-icon-cache" "gtk4-update-icon-cache"
    substituteInPlace ./frog/language_manager.py --subst-var out
  '';

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    glib
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = [
    librsvg
    libnotify
    libadwaita
    libportal
    zbar
    tesseract5
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    pillow
    pytesseract
    pyzbar
  ];

  # This is to prevent double-wrapping the package. We'll let
  # Python do it by adding certain arguments inside of the
  # wrapper instead.
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    homepage = "https://getfrog.app/";
    description =
      "Intuitive text extraction tool (OCR) for GNOME desktop";
    license = licenses.mit;
    maintainers = with maintainers; [ foo-dogsquared ];
    platforms = platforms.linux;
  };
}
