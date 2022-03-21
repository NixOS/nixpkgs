{ python3Packages
, lib
, fetchFromGitHub
, perlPackages
, gettext
, gtk3
, gobject-introspection
, intltool, wrapGAppsHook, glib
, librsvg
, libayatana-appindicator-gtk3
, libpulseaudio
, keybinder3
, gdk-pixbuf
}:

python3Packages.buildPythonApplication rec {
  pname = "indicator-sound-switcher";
  version = "2.3.7";

  src = fetchFromGitHub {
    owner = "yktoo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-agzU3Z3E6NvCnlsz9L719LqMTm8EmYg3TY/2lWTYgKs=";
  };

  postPatch = ''
    substituteInPlace lib/indicator_sound_switcher/lib_pulseaudio.py \
      --replace "CDLL('libpulse.so.0')" "CDLL('${libpulseaudio}/lib/libpulse.so')"
  '';

  nativeBuildInputs = [
    gettext
    intltool
    wrapGAppsHook
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
    libayatana-appindicator-gtk3
    libpulseaudio
    keybinder3
  ];

  meta = with lib; {
    description = "Sound input/output selector indicator for Linux";
    homepage = "https://yktoo.com/en/software/sound-switcher-indicator/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ alexnortung ];
    platforms = [ "x86_64-linux" ];
  };
}
