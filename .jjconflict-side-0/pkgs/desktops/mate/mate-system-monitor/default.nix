{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, itstool
, gtkmm3
, libxml2
, libgtop
, librsvg
, polkit
, systemd
, wrapGAppsHook3
, mate-desktop
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-system-monitor";
  version = "1.28.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "QtZj1rkPtTYevBP2VHmD1vHirHXcKuTxysbqYymWWiU=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    wrapGAppsHook3
  ];

  buildInputs = [
    gtkmm3
    libxml2
    libgtop
    librsvg
    polkit
    systemd
  ];

  postPatch = ''
    # This package does not provide mate-version.xml.
    substituteInPlace src/sysinfo.cpp \
      --replace-fail 'DATADIR "/mate-about/mate-version.xml"' '"${mate-desktop}/share/mate-about/mate-version.xml"'
  '';

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "System monitor for the MATE desktop";
    mainProgram = "mate-system-monitor";
    homepage = "https://mate-desktop.org";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
