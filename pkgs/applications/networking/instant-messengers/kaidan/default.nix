{ mkDerivation, lib, fetchFromGitLab, extra-cmake-modules
, kirigami2
, knotifications
, qtquickcontrols2
, qxmpp }:

mkDerivation rec {
  pname = "kaidan";
  version = "0.4.1";

  src = fetchFromGitLab {
    owner = "kde";
    repo = pname;
    domain = "invent.kde.org";
    rev = "v${version}";
    sha256 = "07ymypcs4whqx8c3s24rha4fkkddnfiqgli5irfkla09ifd12zfz";
  };

  nativeBuildInputs = [
    extra-cmake-modules
  ];

  propagatedBuildInputs = [
    kirigami2
    knotifications
    qtquickcontrols2
    qxmpp
  ];

  meta = with lib; {
    description = "Simple and user-friendly Jabber/XMPP client for every device and platform";
    homepage = "https://invent.kde.org/kde/kaidan/";
    platforms = platforms.linux;
    license = with licenses; [ gpl3Plus mit asl20 ];
    maintainers = with maintainers; [ ajs124 ];
  };
}
