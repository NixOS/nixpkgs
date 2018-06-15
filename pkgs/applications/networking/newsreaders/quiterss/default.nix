{ stdenv, fetchFromGitHub, qmake, pkgconfig
, qtbase, qttools, qtwebkit, sqlite
}:

stdenv.mkDerivation rec {
  name = "quiterss-${version}";
  version = "0.18.11";

  src = fetchFromGitHub {
    owner = "QuiteRSS";
    repo = "quiterss";
    rev = "${version}";
    sha256 = "0n9byhibi2qpgrb7x08knvqnmyn5c7vm24cl6y3zcvz52pz8y2yc";
  };

  # Revert this commit until qt5.qtwebkit (currently an older version) from
  # nixpkgs supports it (the commit states WebKit 602.1 while the current
  # version in nixos-unstable is 538.1)
  patches = [ ./0001-Revert-change-WebKit-602.1-c2f.patch ];

  nativeBuildInputs = [ qmake pkgconfig ];
  buildInputs = [ qtbase qttools qtwebkit sqlite.dev ];

  meta = with stdenv.lib; {
    description = "A Qt-based RSS/Atom news feed reader";
    longDescription = ''
      QuiteRSS is a open-source cross-platform RSS/Atom news feeds reader
      written on Qt/C++
    '';
    homepage = https://quiterss.org;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
