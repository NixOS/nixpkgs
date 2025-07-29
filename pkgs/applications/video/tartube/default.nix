{
  lib,
  fetchFromGitHub,
  gdk-pixbuf,
  gobject-introspection,
  gtk3,
  libnotify,
  pango,
  python3Packages,
  wrapGAppsHook3,
  youtube-dl,
  glib,
  ffmpeg,
  aria2,
}:

python3Packages.buildPythonApplication rec {
  pname = "tartube";
  version = "2.5.100";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "axcore";
    repo = "tartube";
    tag = "v${version}";
    sha256 = "sha256-zocFQRpYbWxG/EoZW419v6li8HBo/9woTBYDbzHR4qQ=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
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
    aria2
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
    description = "GUI front-end for youtube-dl";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mkg20001 ];
    homepage = "https://tartube.sourceforge.io/";
    mainProgram = "tartube";
  };
}
