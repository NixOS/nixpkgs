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
  version = "1.3.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${pname}-kde-${version}.tar.xz";
    sha256 = "0gzv55hks6j37pf7d18l40n1q6j8b74j9qg3v44p8sp0gnglwkcm";
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
