{ lib, fetchFromGitHub, python3, python3Packages, intltool
, glibcLocales, gnome, gtk3, wrapGAppsHook
, gobject-introspection
}:

python3Packages.buildPythonApplication rec {
  pname = "gpodder";
  version = "3.10.17";
  format = "other";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0wrk8d4q6ricbcjzlhk10vrk1qg9hi323kgyyd0c8nmh7a82h8pd";
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
  ];

  # as of 2021-07, the gobject-introspection setup hook does not
  # work with `strictDeps` enabled, thus for proper `wrapGAppsHook`
  # it needs to be disabled explicitly. https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  buildInputs = [
    python3
    gtk3
    gobject-introspection
    gnome.adwaita-icon-theme
  ];

  checkInputs = with python3Packages; [
    coverage minimock
  ];

  doCheck = true;

  propagatedBuildInputs = with python3Packages; [
    feedparser
    dbus-python
    mygpoclient
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
    LC_ALL=C PYTHONPATH=./src:$PYTHONPATH python3 -m gpodder.unittests
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
