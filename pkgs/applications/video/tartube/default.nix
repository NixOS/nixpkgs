{ stdenv
, lib
, fetchFromGitHub
, gdk-pixbuf
, gobject-introspection
, gtk3
, libnotify
, pango
, python3Packages
, wrapGAppsHook
, youtube-dl
, glib
}:

python3Packages.buildPythonApplication rec {
  pname = "tartube";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "axcore";
    repo = "tartube";
    rev = "v${version}";
    sha256 = "1klqjwqm29y2f6nc8gn222ykfvb5d64z1w2kifw9bq5bv0np9bda";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  strictDeps = false;

  propagatedBuildInputs = with python3Packages; [
    moviepy
    pygobject3
    pyxdg
    requests
    feedparser
    playsound
  ];

  buildInputs = [
    gdk-pixbuf
    gtk3
    glib
    libnotify
    pango
  ];

  postPatch = ''
    sed -i "/^\s*install_requires/s/, 'gi'\|'gi', \|'gi'//" setup.py
  '';

  postInstall = ''
    mkdir -p $out/share/{man/man1,applications,pixmaps}
    cp pack/tartube.1 $out/share/man/man1
    cp pack/tartube.desktop $out/share/applications
    cp pack/tartube.{png,xpm} $out/share/pixmaps
  '';

  doCheck = false;

  makeWrapperArgs = [
    "--prefix PATH : ${stdenv.lib.makeBinPath [ youtube-dl ]}"
  ];

  meta = with lib; {
    description = "A GUI front-end for youtube-dl";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mkg20001 luc65r ];
    homepage = "https://tartube.sourceforge.io/";
  };
}
