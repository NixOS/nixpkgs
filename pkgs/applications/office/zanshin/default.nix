{ mkDerivation
, lib
, fetchurl
, extra-cmake-modules
, boost
, akonadi-calendar
, kontactinterface
, krunner
}:

mkDerivation rec {
  pname = "zanshin";
  version = "21.12.1";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${version}/src/zanshin-${version}.tar.xz";
    sha256 = "sha256-hYbJwmnD9i/SL5ET2t9YgPxJHJUpAbMZ4a62WljhpHw=";
  };

  nativeBuildInputs = [
    extra-cmake-modules
  ];

  buildInputs = [
    boost
    akonadi-calendar
    kontactinterface
    krunner
  ];

  meta = with lib; {
    description = "A powerful yet simple application to manage your day to day actions, getting your mind like water";
    homepage = "https://zanshin.kde.org/";
    maintainers = with maintainers; [ zraexy ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
