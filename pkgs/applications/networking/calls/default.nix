{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, cmake
, pkg-config
, libhandy
, modemmanager
, gtk3
, gom
, gsound
, feedbackd
, callaudiod
, evolution-data-server
, folks
, desktop-file-utils
, libpeas
, dbus
, vala
, wrapGAppsHook
, xorg
, xvfb_run
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "calls";
  version = "0.2.0";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qmjdhnr95dawccw1ss8hc3lk0cypj86xg2amjq7avzn86ryd76l";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    vala
    cmake
    wrapGAppsHook
  ];

  buildInputs = [
    modemmanager
    libhandy
    evolution-data-server
    folks
    gom
    gsound
    feedbackd
    callaudiod
    gtk3
    libpeas
  ];

  checkInputs = [
    dbus
    xvfb_run
  ];

  mesonFlags = [
    # docs fail to build
    # https://source.puri.sm/Librem5/calls/issues/99
    "-Dgtk_doc=false"
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    NO_AT_BRIDGE=1 \
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --print-errorlogs
    runHook postCheck
  '';

  meta = with lib; {
    description = "A phone dialer and call handler";
    homepage = "https://source.puri.sm/Librem5/calls";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ craigem lheckemann ];
    platforms = platforms.linux;
  };
}
