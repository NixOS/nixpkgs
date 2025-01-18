{
  lib,
  stdenv,
  fetchFromGitLab,
  c-ares,
  dbus,
  glib,
  libphonenumber,
  libsoup_3,
  meson,
  mobile-broadband-provider-info,
  modemmanager,
  ninja,
  pkg-config,
  protobuf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mmsd-tng";
  version = "2.6.2";

  src = fetchFromGitLab {
    owner = "kop316";
    repo = "mmsd";
    rev = finalAttrs.version;
    hash = "sha256-iusA5SXBulROBG6SmlYfw/FczLMnNeBb398+9cYx/A0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    c-ares
    dbus
    glib
    libphonenumber
    libsoup_3
    mobile-broadband-provider-info
    modemmanager
    protobuf
  ];

  doCheck = true;

  meta = with lib; {
    description = "Multimedia Messaging Service Daemon - The Next Generation";
    homepage = "https://gitlab.com/kop316/mmsd";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ julm ];
    platforms = platforms.linux;
    mainProgram = "mmsdtng";
  };
})
