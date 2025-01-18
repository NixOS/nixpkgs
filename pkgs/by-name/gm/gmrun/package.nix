{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gmrun";
  version = "1.4w";

  src = fetchFromGitHub {
    owner = "wdlkmpx";
    repo = "gmrun";
    tag = finalAttrs.version;
    hash = "sha256-sp+Atod9ZKVF8sxNWIMrlewqZAGnoLo2mZUNkCtSkec=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  doCheck = true;

  enableParallelBuilding = true;

  # Problem with component size on wayland
  preFixup = ''
    gappsWrapperArgs+=(--set-default GDK_BACKEND x11)
  '';

  meta = with lib; {
    description = "Gnome Completion-Run Utility";
    longDescription = ''
      A simple program which provides a "run program" window, featuring a bash-like TAB completion.
      It uses GTK interface.
      Also, supports CTRL-R / CTRL-S / "!" for searching through history.
      Running commands in a terminal with CTRL-Enter. URL handlers.
    '';
    homepage = "https://github.com/wdlkmpx/gmrun";
    license = licenses.isc;
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
    mainProgram = "gmrun";
  };
})
