{ stdenv, fetchFromGitHub
, doxygen, python3Packages, libopenshot
, wrapGAppsHook, gtk3 }:

python3Packages.buildPythonApplication rec {
  name = "openshot-qt-${version}";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "openshot-qt";
    rev = "v${version}";
    sha256 = "1qdw1mli4y9qhrnllnkaf6ydgw5vfvdb90chs4i679k0x0jyb9a2";
  };

  nativeBuildInputs = [ doxygen wrapGAppsHook ];

  buildInputs = [ gtk3 ];

  propagatedBuildInputs = with python3Packages; [ libopenshot pyqt5_with_qtwebkit requests sip httplib2 pyzmq ];


  preConfigure = ''
    # tries to create caching directories during install
    export HOME=$(mktemp -d)
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://openshot.org/;
    description = "Free, open-source video editor";
    longDescription = ''
      OpenShot Video Editor is a free, open-source video editor for Linux.
      OpenShot can take your videos, photos, and music files and help you
      create the film you have always dreamed of. Easily add sub-titles,
      transitions, and effects, and then export your film to DVD, YouTube,
      Vimeo, Xbox 360, and many other common formats.
    '';
    license = with licenses; gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; linux;
  };
}
