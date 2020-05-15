{ stdenv
, fetchFromGitHub
, meson
, ninja
, gettext
, desktop-file-utils
, appstream-glib
, pkgconfig
, txt2man
, gzip
, vala
, wrapGAppsHook
, gsettings-desktop-schemas
, gtk3
, glib
, cairo
, keybinder3
, ffmpeg
, python3
, libxml2
, gst_all_1
, which
, gifski
}:

stdenv.mkDerivation rec {
  pname = "peek";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "phw";
    repo = "peek";
    rev = version;
    sha256 = "1xwlfizga6hvjqq127py8vabaphsny928ar7mwqj9cyqfl6fx41x";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    gzip
    meson
    ninja
    libxml2
    pkgconfig
    txt2man
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    cairo
    glib
    gsettings-desktop-schemas
    gtk3
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    keybinder3
  ];

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py data/man/build_man.sh
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${stdenv.lib.makeBinPath [ which ffmpeg gifski ]})
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/phw/peek";
    description = "Simple animated GIF screen recorder with an easy to use interface";
    license = licenses.gpl3;
    maintainers = with maintainers; [ puffnfresh worldofpeace ];
    platforms = platforms.linux;
  };
}
