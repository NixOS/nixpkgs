{
  python3Packages,
  lib,
  fetchFromGitHub,
  gettext,
  gtk3,
  gobject-introspection,
  intltool,
  wrapGAppsHook3,
  glib,
  librsvg,
  libayatana-appindicator,
  libpulseaudio,
  keybinder3,
  gdk-pixbuf,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "indicator-sound-switcher";
  version = "2.3.10.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "yktoo";
    repo = "indicator-sound-switcher";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-Benhlhz81EgL6+pmjzyruKBOS6O7ce5PPmIIzk2Zong=";
  };

  postPatch = ''
    substituteInPlace lib/indicator_sound_switcher/lib_pulseaudio.py \
      --replace "CDLL('libpulse.so.0')" "CDLL('${libpulseaudio}/lib/libpulse.so')"
  '';

  nativeBuildInputs = [
    gettext
    intltool
    wrapGAppsHook3
    glib
    gdk-pixbuf
    gobject-introspection
  ];

  buildInputs = [
    librsvg
  ];

  propagatedBuildInputs = [
    python3Packages.setuptools
    python3Packages.pygobject3
    gtk3
    librsvg
    libayatana-appindicator
    libpulseaudio
    keybinder3
  ];

  meta = {
    description = "Sound input/output selector indicator for Linux";
    mainProgram = "indicator-sound-switcher";
    homepage = "https://yktoo.com/en/software/sound-switcher-indicator/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ alexnortung ];
    platforms = [ "x86_64-linux" ];
  };
})
