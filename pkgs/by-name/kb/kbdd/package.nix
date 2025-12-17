{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  dbus-glib,
  autoreconfHook,
  libX11,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kbdd";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "qnikst";
    repo = "kbdd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hl8zrF5aegVUQtLjf0FTacp4t3pcb2pJn5y0lV85eGI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libX11
    dbus-glib
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple daemon and library to make per window layout using XKB";
    homepage = "https://github.com/qnikst/kbdd";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ chillcicada ];
    mainProgram = "kbdd";
  };
})
