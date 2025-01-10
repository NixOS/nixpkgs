{ lib
, fetchFromGitHub
, gitUpdater
, glibcLocales
, adwaita-icon-theme
, gobject-introspection
, gtk3
, intltool
, python311Packages
, wrapGAppsHook3
, xdg-utils
}:

python311Packages.buildPythonApplication rec {
  pname = "gpodder";
  version = "3.11.4";
  format = "other";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "kEhyV1o8VSQW9qMx6m5avj6LnJuVTONDd6msRuc8t/4=";
  };

  patches = [
    ./disable-autoupdate.patch
  ];

  postPatch = ''
    sed -i -re 's,^( *gpodder_dir *= *).*,\1"'"$out"'",' bin/gpodder
  '';

  nativeBuildInputs = [
    intltool
    wrapGAppsHook3
    glibcLocales
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    adwaita-icon-theme
  ];

  nativeCheckInputs = with python311Packages; [
    minimock
    pytest
    pytest-httpserver
    pytest-cov
  ];

  doCheck = true;

  propagatedBuildInputs = with python311Packages; [
    feedparser
    dbus-python
    mygpoclient
    requests
    pygobject3
    eyed3
    podcastparser
    html5lib
    mutagen
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "share/applications/gpodder-url-handler.desktop"
    "share/applications/gpodder.desktop"
    "share/dbus-1/services/org.gpodder.service"
  ];

  preBuild = ''
    export LC_ALL="en_US.UTF-8"
  '';

  installCheckPhase = ''
    LC_ALL=C PYTHONPATH=src/:$PYTHONPATH pytest --ignore=tests --ignore=src/gpodder/utilwin32ctypes.py --doctest-modules src/gpodder/util.py src/gpodder/jsonconfig.py
    LC_ALL=C PYTHONPATH=src/:$PYTHONPATH pytest tests --ignore=src/gpodder/utilwin32ctypes.py --ignore=src/mygpoclient --cov=gpodder
  '';

  makeWrapperArgs = [ "--suffix PATH : ${lib.makeBinPath [ xdg-utils ]}" ];

  passthru.updateScript = gitUpdater {};

  meta = with lib; {
    description = "Podcatcher written in python";
    longDescription = ''
      gPodder downloads and manages free audio and video content (podcasts)
      for you. Listen directly on your computer or on your mobile devices.
    '';
    homepage = "http://gpodder.org/";
    license = licenses.gpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mic92 ];
  };
}
