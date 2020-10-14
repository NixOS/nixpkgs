{ mkDerivation
, lib
, fetchurl
, fetchpatch
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
, qtmultimedia
, qtgraphicaleffects
, sshfs
, makeWrapper
, kwayland
, kio
, kpeoplevcard
, kpeople
, kirigami2
, pulseaudio-qt
}:

mkDerivation rec {
  pname = "kdeconnect";
  version = "20.08.1";

  src = fetchurl {
    url = "https://download.kde.org/stable/release-service/${version}/src/${pname}-kde-${version}.tar.xz";
    sha256 = "0s76djgpx08jfmh99c7kx18mnr3w7bv4hdra120nicq89mmy7gwf";
  };

  patches = [
    # https://invent.kde.org/network/kdeconnect-kde/-/merge_requests/328
    (fetchpatch {
      url = "https://invent.kde.org/network/kdeconnect-kde/-/commit/6101ef3ad07d865958d58a3d2736f5536f1c5719.diff";
      sha256 = "17mr7k13226vzcgxlmfs6q2mdc5j7vwp4iri9apmh6xlf6r591ac";
    })
  ];

  buildInputs = [
    libfakekey
    libXtst
    qtmultimedia
    qtgraphicaleffects
    pulseaudio-qt
    kpeoplevcard
    kpeople
    kirigami2
    ki18n
    kiconthemes
    kcmutils
    kconfigwidgets
    kdbusaddons
    knotifications
    qca-qt5
    qtx11extras
    makeWrapper
    kwayland
    kio
  ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  postInstall = ''
    wrapProgram $out/libexec/kdeconnectd --prefix PATH : ${lib.makeBinPath [ sshfs ]}
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "KDE Connect provides several features to integrate your phone and your computer";
    homepage    = "https://community.kde.org/KDEConnect";
    license     = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ fridh ];
  };
}
