{ lib
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
, ffmpeg
, aria
}:

python3Packages.buildPythonApplication rec {
  pname = "tartube";
  version = "2.3.110";

  src = fetchFromGitHub {
    owner = "axcore";
    repo = "tartube";
    rev = "v${version}";
    sha256 = "0sdbd2lsc4bvgkwi55arjwbzwmq05abfmv6vsrvz4gsdv8s8wha5";
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
    ffmpeg
    matplotlib
    aria
  ];

  buildInputs = [
    gdk-pixbuf
    gtk3
    glib
    libnotify
    pango
  ];

  postPatch = ''
    sed -i "/^\s*'pgi',$/d" setup.py
  '';

  postInstall = ''
    mkdir -p $out/share/{man/man1,applications,pixmaps}
    cp pack/tartube.1 $out/share/man/man1
    cp pack/tartube.desktop $out/share/applications
    cp pack/tartube.{png,xpm} $out/share/pixmaps
  '';

  doCheck = false;

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ youtube-dl ]}"
  ];

  meta = with lib; {
    description = "A GUI front-end for youtube-dl";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mkg20001 luc65r ];
    homepage = "https://tartube.sourceforge.io/";
  };
}
