{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finaAttrs: {
  pname = "scom";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "crash-systems";
    repo = "scom";
    tag = finaAttrs.version;
    hash = "sha256-fFA0s+B94YPDvcPi2GCThcMGcSY6qR1f7x/jP8gXh94=";
  };

  # Fix build w/ glibc-2.42.
  # Upstream PR: https://github.com/crash-systems/scom/pull/1
  postPatch = ''
    substituteInPlace src/common.h --replace-fail termio.h termios.h
  '';

  enableParallelBuilding = true;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Minimal serial communication tool";
    homepage = "https://github.com/crash-systems/scom";
    mainProgram = "scom";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ savalet ];
    platforms = lib.platforms.unix;
  };
})
