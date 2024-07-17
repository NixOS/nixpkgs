{
  lib,
  fetchFromGitHub,
  python3Packages,
  wrapGAppsHook4,
  meson,
  ninja,
  pkg-config,
  appstream-glib,
  desktop-file-utils,
  glib,
  gobject-introspection,
  blueprint-compiler,
  libxml2,
  libnotify,
  libadwaita,
  libportal,
  gettext,
  librsvg,
  tesseract5,
  zbar,
  gst_all_1,
}:

python3Packages.buildPythonApplication rec {
  pname = "gnome-frog";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "TenderOwl";
    repo = "Frog";
    rev = "refs/tags/${version}";
    sha256 = "sha256-zL6zuqHF1pTXT3l1mAFx2EL+0ThzjXfst/nEyNVorZg=";
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
    blueprint-compiler
    libxml2
  ];

  buildInputs = [
    librsvg
    libnotify
    libadwaita
    libportal
    zbar
    tesseract5
    gst_all_1.gstreamer
  ];

  propagatedBuildInputs = with python3Packages; [
    loguru
    nanoid
    posthog
    pygobject3
    python-dateutil
    pillow
    pytesseract
    pyzbar
    gtts
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
    description = "Intuitive text extraction tool (OCR) for GNOME desktop";
    license = licenses.mit;
    mainProgram = "frog";
    maintainers = with maintainers; [ foo-dogsquared ];
    platforms = platforms.linux;
  };
}
