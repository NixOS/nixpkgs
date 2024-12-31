{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  unixtools,
  dbus,
  libcap,
  polkit,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "rtkit";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "heftig";
    repo = "rtkit";
    rev = "c295fa849f52b487be6433e69e08b46251950399";
    sha256 = "0yfsgi3pvg6dkizrww1jxpkvcbhzyw9110n1dypmzq0c5hlzjxcd";
  };

  patches = [
    ./meson-actual-use-systemd_systemunitdir.patch
    ./meson-fix-librt-find_library-check.patch
    ./rtkit-daemon-dont-log-debug-messages-by-default.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    unixtools.xxd
  ];
  buildInputs = [
    dbus
    libcap
    polkit
    systemd
  ];

  mesonFlags = [
    "-Dinstalled_tests=false"

    "-Ddbus_systemservicedir=${placeholder "out"}/share/dbus-1/system-services"
    "-Ddbus_interfacedir=${placeholder "out"}/share/dbus-1/interfaces"
    "-Ddbus_rulesdir=${placeholder "out"}/etc/dbus-1/system.d"
    "-Dpolkit_actiondir=${placeholder "out"}/share/polkit-1/actions"
    "-Dsystemd_systemunitdir=${placeholder "out"}/etc/systemd/system"
  ];

  meta = with lib; {
    homepage = "https://github.com/heftig/rtkit";
    description = "Daemon that hands out real-time priority to processes";
    mainProgram = "rtkitctl";
    license = with licenses; [
      gpl3
      bsd0
    ]; # lib is bsd license
    platforms = platforms.linux;
  };
}
