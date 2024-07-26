{
  lib,
  python3Packages,
  fetchFromGitHub,
  gtk3,
  cava,
  gst_all_1,
  gobject-introspection,
  wrapGAppsHook3,
  makeDesktopItem,
  fetchurl,
}:

python3Packages.buildPythonApplication rec {
  pname = "cavalcade";
  version = "0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "worron";
    repo = "cavalcade";
    rev = "refs/tags/${version}";
    hash = "sha256-VyWOPNidN0+pfuxsgPWq6lI5gXQsiRpmYjQYjZW6i9w=";
  };

  postPatch = ''
    substituteInPlace cavalcade/cava.py \
      --replace-fail '"cava"' '"${cava}/bin/cava"'
  '';

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    pygobject3
    gst-python
    pillow
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
    gst_all_1.gstreamer
  ];

  buildInputs = [ gtk3 ];

  desktopItems = [
    (makeDesktopItem {
      name = "Cavalcade";
      type = "Application";
      exec = "cavalcade";
      icon = fetchurl {
        url = "https://raw.githubusercontent.com/worron/cavalcade/devel/desktop/cavalcade.svg";
        hash = "sha256-GJR5kUmSnFG6dE+o2UWKaHmiKPZNDGZZqXCIP8o883M=";
      };
      comment = "CAVA GUI";
      categories = [
        "AudioVideo"
        "Audio"
        "GTK"
      ];
      desktopName = "Cavalcade";
    })
  ];

  meta = {
    description = "Python wrapper for C.A.V.A. utility with a GUI";
    homepage = "https://github.com/worron/cavalcade";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
