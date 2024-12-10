{
  python3Packages,
  lib,
  fetchFromGitHub,
  perlPackages,
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

python3Packages.buildPythonApplication rec {
  pname = "indicator-sound-switcher";
  version = "2.3.9";

  src = fetchFromGitHub {
    owner = "yktoo";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-qJ1lg9A1aCM+/v/JbQAVpYGX25qA5ULqsM8k7uH1uvQ=";
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
  ];

  buildInputs = [
    librsvg
  ];

  propagatedBuildInputs = [
    python3Packages.setuptools
    python3Packages.pygobject3
    gtk3
    gobject-introspection
    librsvg
    libayatana-appindicator
    libpulseaudio
    keybinder3
  ];

  meta = with lib; {
    description = "Sound input/output selector indicator for Linux";
    mainProgram = "indicator-sound-switcher";
    homepage = "https://yktoo.com/en/software/sound-switcher-indicator/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ alexnortung ];
    platforms = [ "x86_64-linux" ];
  };
}
