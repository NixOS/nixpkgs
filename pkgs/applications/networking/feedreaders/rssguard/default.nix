{ stdenv, fetchFromGitHub, qmakeHook, qtwebengine, qttools }:

stdenv.mkDerivation rec {
  name = "rssguard-${version}";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "martinrotter";
    repo = "rssguard";
    # fetchFromGitHub doesn't support rev being a tag when fetchSubmodules=true,
    # so need to use the hash commit. See:
    # https://github.com/NixOS/nixpkgs/issues/26302
    #rev = "${version}";
    rev = "cb15ba92c9bc1b80e2b81d7976438e562ee1ef90";
    sha256 = "1cdpfjj2lm1q2qh0w0mh505blcmi4n78458d3z3c1zn9ls9b9zsp";
    fetchSubmodules = true;
  };

  buildInputs =  [ qmakeHook qtwebengine qttools ];

  preConfigure = ''
    qmakeFlags="$qmakeFlags CONFIG+=release"
  '';

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
