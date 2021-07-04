{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, libhandy
, libphonenumber
, libgcrypt
, pidgin
, protobuf
, modemmanager
, folks
, gtk3
, gom
, feedbackd
, evolution-data-server
, glib
, desktop-file-utils
, appstream-glib
, libgdata
, olm
, dbus
, vala
, wrapGAppsHook
, xvfb-run
, python3
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "chatty";
  version = "0.3.2";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kznkcm1pdp9m21swwzzlpb44qmgvmc233k0ngdp56f1qz522pzy";
  };

  patches = [
    # https://source.puri.sm/Librem5/chatty/-/issues/508
    ./disable-accounts-test.patch
  ];

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    appstream-glib
    vala
    wrapGAppsHook
    python3
  ];

  buildInputs = [
    evolution-data-server
    gom
    feedbackd
    gtk3
    libgcrypt
    libgdata # required by some dependency transitively
    libhandy
    libphonenumber
    modemmanager
    pidgin
    protobuf
    olm
    sqlite
  ];

  checkInputs = [
    dbus
    xvfb-run
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    NO_AT_BRIDGE=1 \
    XDG_DATA_DIRS=${folks}/share/gsettings-schemas/${folks.name} \
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --print-errorlogs
    runHook postCheck
  '';

  meta = with lib; {
    description = "XMPP and SMS messaging via libpurple and Modemmanager";
    homepage = "https://source.puri.sm/Librem5/chatty";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tomfitzhenry ];
    platforms = platforms.linux;
  };
}
