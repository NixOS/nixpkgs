{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  glib,
  ddcutil,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ddcutil-service";
  version = "1.0.15";

  src = fetchFromGitHub {
    owner = "digitaltrails";
    repo = "ddcutil-service";
    rev = "v${finalAttrs.version}";
    hash = "sha256-r66Ua+4jGl1wFEX3RoRHN60GujNApGbDHtJnVDtP3Z4=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
    ddcutil
  ];

  # Also installs ddcutil-client, which is built by default
  installTargets = "install-all";

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "A Dbus ddcutil server for control of DDC Monitors/VDUs";
    homepage = "https://github.com/digitaltrails/ddcutil-service";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "ddcutil-service";
    platforms = lib.platforms.linux;
  };
})
