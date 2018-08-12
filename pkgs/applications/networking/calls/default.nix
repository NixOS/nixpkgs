{ stdenv
, fetchFromGitLab
, meson
, ninja
, pkgconfig
, desktop-file-utils
, appstream-glib
, libxml2
, wrapGAppsHook
, libhandy
, glib
, gtk3
, gsound
, libpeas
, modemmanager
, dbus
, xvfb_run
}:

stdenv.mkDerivation rec {
  pname = "calls";
  version = "unstable-2019-01-31";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "ee126b3660c8c44dcb67c695d0c7911160995971";
    sha256 = "1qwyqs5psnr5jgllsbkayy1ik24nv7b8if26b9440qv2h6kc9gd7";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    desktop-file-utils
    appstream-glib
    libxml2
    wrapGAppsHook
  ];

  buildInputs = [
    libhandy
    glib
    gtk3
    gsound
    libpeas
    modemmanager
  ];

  checkInputs = [
    dbus
    xvfb_run
  ];

  doCheck = true;

  checkPhase = ''
    export NO_AT_BRIDGE=1
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --print-errorlogs
  '';

  meta = with stdenv.lib; {
    description = "A phone dialer and call handler";
    homepage = https://source.puri.sm/Librem5/calls;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
