{ lib
, fetchFromGitHub
, gnumake
, gtk3
, setproctitle
, python-rtmidi
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "microdude";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "dagargo";
    repo = "microdude";
    rev = "2.3";
    sha256 = "sha256-t3P6JMu//agRcLNtvcXki70kqlc4ed0P/oLYIL/2DcE=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  buildInputs = [
    python-rtmidi
  ];

  propagatedBuildInputs = with python3Packages; [
    mido
    pygobject3
    setproctitle
    setuptools
  ];

  installPhase = ''
    substituteInPlace Makefile \
      --replace "python3 setup.py install" "" \
      --replace gtk-update-icon-cache "gtk-update-icon-cache --ignore-theme-index" \
      --replace '/usr/share/$$locale' $out/share/locale
    make \
      ICON_THEME_DIR=$out/share/icons \
      BINDIR=$out/bin \
      DESKTOP_FILES_DIR=$out/share/applications \
      install
  '';

  meta = with lib; {
    homepage = "https://github.com/dagargo/microdude";
    description = "Editor for Arturia MicroBrute";
    longDescription = ''
      MicroDude is an editor for Arturia MicroBrute. It offers all the
      functionality of Arturia MicroBrute Connection but the firmware upload
      and the factory patterns reset.
    '';
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ andrewb ];
  };
}
