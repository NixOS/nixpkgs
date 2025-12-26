{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  glib,
  gtk3,
  gettext,
  pango,
  makeWrapper,
  pcre2,
  perl,
  pkg-config,
  vte,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sakura";
  version = "3.8.8";

  src = fetchFromGitHub {
    owner = "dabisu";
    repo = "sakura";
    rev = "SAKURA_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-YeZIYIfFgkK5nxMHq9mslrjIWTRAebhXyzXv5hTmOpI=";
  };

  nativeBuildInputs = [
    cmake
    gettext
    makeWrapper
    perl
    pkg-config
  ];

  buildInputs = [
    glib
    gtk3
    pango
    pcre2
    vte
  ];

  strictDeps = true;

  # Set path to gsettings-schemata so sakura knows where to find colorchooser,
  # fontchooser etc.
  postFixup = ''
    wrapProgram $out/bin/sakura \
      --suffix XDG_DATA_DIRS : ${gtk3}/share/gsettings-schemas/${gtk3.name}/
  '';

  passthru.tests.test = nixosTests.terminal-emulators.sakura;

  meta = {
    homepage = "https://www.pleyades.net/david/projects/sakura";
    description = "Terminal emulator based on GTK and VTE";
    longDescription = ''
      sakura is a terminal emulator based on GTK and VTE. It's a terminal
      emulator with few dependencies, so you don't need a full GNOME desktop
      installed to have a decent terminal emulator. Current terminal emulators
      based on VTE are gnome-terminal, XFCE Terminal, TermIt and a small
      sample program included in the vte sources. The differences between
      sakura and the last one are that it uses a notebook to provide several
      terminals in one window and adds a contextual menu with some basic
      options. No more no less.
    '';
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      codyopel
    ];
    platforms = lib.platforms.linux;
    mainProgram = "sakura";
  };
})
