{ stdenv, fetchgit, qmake, qtwebengine, qttools, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "rssguard-${version}";
  version = "3.4.2";

  src = fetchgit {
    url = https://github.com/martinrotter/rssguard;
    rev = "refs/tags/${version}";
    sha256 = "0iy0fd3qr2dm0pc6xr7sin6cjfxfa0pxhxiwzs55dhsdk9zir62s";
    # Submodules are required only for Windows (and one of them is a huge binary
    # package ~400MB). See project wiki for more details.
    fetchSubmodules = false;
  };

  buildInputs =  [ qtwebengine qttools ];
  nativeBuildInputs = [ qmake wrapGAppsHook ];
  qmakeFlags = [ "CONFIG+=release" ];

  meta = with stdenv.lib; {
    description = "Simple RSS/Atom feed reader with online synchronization";
    longDescription = ''
      RSS Guard is a simple, light and easy-to-use RSS/ATOM feed aggregator
      developed using Qt framework and with online feed synchronization support
      for ownCloud/Nextcloud.
    '';
    homepage = https://github.com/martinrotter/rssguard;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
