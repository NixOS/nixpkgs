{ stdenv, fetchFromGitHub, qmake, qtwebengine, qttools, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "rssguard";
  version = "3.5.6";

  src = fetchFromGitHub {
    owner = "martinrotter";
    repo = pname;
    rev = version;
    sha256 = "1pdas7hg3nzykm3qi951fk25c9s6gjb7my82b9xzjn2yd7ks71by";
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
