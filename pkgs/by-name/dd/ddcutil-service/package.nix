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
  version = "1.0.14";

  src = fetchFromGitHub {
    owner = "digitaltrails";
    repo = "ddcutil-service";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IZ6s9z0zxMZT7qd+yuQJGLnKc1WISIvhJlIGsM/Dw3w=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
    ddcutil
  ];

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
