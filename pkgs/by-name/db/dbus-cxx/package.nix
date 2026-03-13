{
  fetchFromGitHub,
  lib,
  stdenv,
  cmake,
  ninja,
  pkg-config,
  libsigcxx30,
  doCheck ? stdenv.hostPlatform == stdenv.buildPlatform,
  expat ? doCheck,
  dbus ? doCheck,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dbus-cxx";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "dbus-cxx";
    repo = "dbus-cxx";
    tag = finalAttrs.version;
    hash = "sha256-jhooz1RsDn8XeLdaAcvlIdAKhLbTFnlwa7/YVYSR+7Y=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  cmakeFlags = [
    "-GNinja"
  ];

  checkInputs = [ expat ];
  nativeCheckInputs = [ dbus ];
  inherit doCheck;
  checkPhase = ''
    runHook preCheck

    DBUS_DIR=$(mktemp -d)
    DBUS_CONFIG=$DBUS_DIR/session.conf
    DBUS_SESSION_BUS_ADDRESS=unix:path=$DBUS_DIR/bus
    cat <<-EOF > $DBUS_CONFIG
!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-Bus Bus Configuration 1.0//EN"
  "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
<busconfig></busconfig>
    EOF
    dbus-daemon --address=DBUS_SESSION_BUS_ADDRESS --fork --config-file=$DBUS_CONFIG
    ctest
    runHook postCheck
  '';

  buildInputs = [ libsigcxx30 ];

  meta = {
    homepage = "https://github.com/dbus-cxx/dbus-cxx";
    description = "Object-oriented interface to DBus";
    license = with lib.licenses; [
      lgpl3Plus
      # or
      bsd3
    ];
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.fredeb ];
  };
})
