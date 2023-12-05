{ lib, stdenv, fetchFromGitHub, fetchpatch, qmake, wrapQtAppsHook, qtbase, exiv2 }:

stdenv.mkDerivation rec {
  pname = "phototonic";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "oferkv";
    repo = "phototonic";
    rev = "v${version}";
    hash = "sha256-BxJgTKblOKIwt88+PT7XZE0mk0t2B4SfsdXpQHttUTM=";
  };

  patches = [
    (fetchpatch {
      name = "exiv2-0.28.patch";
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/phototonic/-/raw/fcfa17307ad8988750cc09200188c9365c2c0b79/exiv2-0.28.patch";
      hash = "sha256-EayJYM4qobUWosxV2Ylj+2eiyhk1jM8OfnFZDbVdGII=";
    })
  ];

  nativeBuildInputs = [ qmake wrapQtAppsHook ];
  buildInputs = [ qtbase exiv2 ];

  preConfigure = ''
    sed -i 's;/usr;$$PREFIX/;g' phototonic.pro
  '';

  meta = with lib; {
    description = "An image viewer and organizer";
    homepage = "https://github.com/oferkv/phototonic";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
