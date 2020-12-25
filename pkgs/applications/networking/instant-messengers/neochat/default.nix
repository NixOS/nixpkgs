{ mkDerivation, stdenv, fetchFromGitLab
, pkgconfig, wrapQtAppsHook
, cmake
, qtbase, qttools, qtquickcontrols2, qtmultimedia, qtkeychain
, libpulseaudio
# Not mentioned but seems needed
, qtgraphicaleffects
, qtdeclarative
, qtmacextras
, olm, libsecret, cmark, extra-cmake-modules, kirigami2, ki18n, knotifications, kdbusaddons, kconfig, libquotient
, KQuickImageEdit, kitemmodels
}:

let
qtkeychain-qt5 = qtkeychain.override {
  inherit qtbase qttools;
  withQt5 = true;
};

in mkDerivation rec {
  pname = "neochat";
  version = "v1.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "network";
    repo = pname;
    rev = version;
    sha256 = "1r9n83kvc5v215lzmzh6hyc5q9i3w6znbf508qk0mdwdzxz4zry9";
  };

  nativeBuildInputs = [ pkgconfig cmake extra-cmake-modules wrapQtAppsHook ];
  buildInputs = [ qtbase qtkeychain-qt5 qtquickcontrols2 qtmultimedia qtgraphicaleffects qtdeclarative olm libsecret cmark kirigami2 ki18n knotifications kdbusaddons kconfig libquotient KQuickImageEdit kitemmodels libpulseaudio ];

  meta = with stdenv.lib; {
    description = "A client for matrix, the decentralized communication protocol.";
    homepage = "https://apps.kde.org/en/neochat";
    license = licenses.gpl3;
    platforms = with platforms; linux;
  };
}
