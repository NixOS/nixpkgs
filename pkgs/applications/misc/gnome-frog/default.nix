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
<<<<<<< HEAD
, blueprint-compiler
, libxml2
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libnotify
, libadwaita
, libportal
, gettext
, librsvg
, tesseract5
, zbar
<<<<<<< HEAD
, gst_all_1
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

python3Packages.buildPythonApplication rec {
  pname = "gnome-frog";
<<<<<<< HEAD
  version = "1.4.2";
=======
  version = "1.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "TenderOwl";
    repo = "Frog";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    sha256 = "sha256-w/ENUhJt7bYy5htBLolb/HysK8/scRaPQX5qEezQcXY=";
=======
    sha256 = "sha256-ErDHrdD9UZxOIGwgN5eakY6vhNvE6D9SoRYXZhzmYX4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    blueprint-compiler
    libxml2
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    librsvg
    libnotify
    libadwaita
    libportal
    zbar
    tesseract5
<<<<<<< HEAD
    gst_all_1.gstreamer
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    pillow
    pytesseract
    pyzbar
<<<<<<< HEAD
    gtts
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    mainProgram = "frog";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ foo-dogsquared ];
    platforms = platforms.linux;
  };
}
