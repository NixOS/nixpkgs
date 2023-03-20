{ lib, fetchFromGitHub, python3, python3Packages, intltool
, glibcLocales, gnome, gtk3, wrapGAppsHook
, gobject-introspection
}:

python3Packages.buildPythonApplication rec {
  pname = "gpodder";
  version = "3.10.21";
  format = "other";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0n73jm5ypsj962gpr0dk10lqh83giqsczm63wchyhmrkyf1wgga1";
  };

  patches = [
    ./disable-autoupdate.patch
  ];

  postPatch = with lib; ''
    sed -i -re 's,^( *gpodder_dir *= *).*,\1"'"$out"'",' bin/gpodder
  '';

  nativeBuildInputs = [
    intltool
    wrapGAppsHook
    glibcLocales
    gobject-introspection
  ];

  buildInputs = [
    python3
    gtk3
    gnome.adwaita-icon-theme
  ];

  nativeCheckInputs = with python3Packages; [
    minimock
    pytest
    pytest-httpserver
    pytest-cov
  ];

  doCheck = true;

  propagatedBuildInputs = with python3Packages; [
    feedparser
    dbus-python
    mygpoclient
    requests
    pygobject3
    eyeD3
    podcastparser
    html5lib
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

  meta = with lib; {
    description = "A podcatcher written in python";
    longDescription = ''
      gPodder downloads and manages free audio and video content (podcasts)
      for you. Listen directly on your computer or on your mobile devices.
    '';
    homepage = "http://gpodder.org/";
    license = licenses.gpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ skeidel mic92 ];
  };
}
