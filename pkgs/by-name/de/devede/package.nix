{
  lib,
  fetchFromGitLab,
  python3Packages,
  ffmpeg,
  mplayer,
  vcdimager,
  cdrkit,
  dvdauthor,
  gtk3,
  gettext,
  wrapGAppsHook3,
  gdk-pixbuf,
  gobject-introspection,
}:

let
  inherit (python3Packages)
    dbus-python
    buildPythonApplication
    pygobject3
    urllib3
    setuptools
    ;
in
buildPythonApplication rec {
  pname = "devede";
  version = "4.17.0";
  namePrefix = "";

  src = fetchFromGitLab {
    owner = "rastersoft";
    repo = "devedeng";
    rev = version;
    hash = "sha256-CdntdD5DRA/eXTBRBRszkbYFeFxj+0odb8XHkAFdobU=";
  };

  nativeBuildInputs = [
    gettext
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    ffmpeg
  ];

  propagatedBuildInputs = [
    gtk3
    pygobject3
    gdk-pixbuf
    dbus-python
    ffmpeg
    mplayer
    dvdauthor
    vcdimager
    cdrkit
    urllib3
    setuptools
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "'/usr'," ""
    substituteInPlace src/devedeng/configuration_data.py \
      --replace "/usr/share" "$out/share" \
      --replace "/usr/local/share" "$out/share"
  '';

  meta = with lib; {
    description = "DVD Creator for Linux";
    homepage = "http://www.rastersoft.com/programas/devede.html";
    license = licenses.gpl3;
    maintainers = [ maintainers.bdimcheff ];
  };
}
