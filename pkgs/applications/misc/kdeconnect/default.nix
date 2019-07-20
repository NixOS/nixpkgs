{ stdenv
, lib
, fetchurl
, extra-cmake-modules
, kcmutils
, kconfigwidgets
, kdbusaddons
, kdoctools
, kiconthemes
, ki18n
, knotifications
, qca-qt5
, libfakekey
, libXtst
, qtx11extras
, sshfs
, makeWrapper
, kwayland
}:

stdenv.mkDerivation rec {
  pname = "kdeconnect";
  version = "1.3.4";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/${pname}-kde-${version}.tar.xz";
    sha256 = "12ijvp86wm6k81dggypxh3c0dmwg5mczxy43ra8rgv63aavmf42h";
  };

  buildInputs = [
    libfakekey libXtst
    ki18n kiconthemes kcmutils kconfigwidgets kdbusaddons knotifications
    qca-qt5 qtx11extras makeWrapper kwayland
  ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  postInstall = ''
    wrapProgram $out/lib/libexec/kdeconnectd --prefix PATH : ${lib.makeBinPath [ sshfs ]}
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "KDE Connect provides several features to integrate your phone and your computer";
    homepage    = https://community.kde.org/KDEConnect;
    license     = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ fridh ];
  };
}
