{
  at-spi2-core,
  cmake,
  dbus,
  dbus-glib,
  docbook_xsl,
  fetchFromGitHub,
  glib,
  gtk3,
  harfbuzz,
  lib,
  libXdmcp,
  libXtst,
  libepoxy,
  libpthreadstubs,
  libselinux,
  libsepol,
  libtasn1,
  libxkbcommon,
  libxslt,
  nixosTests,
  p11-kit,
  pcre2,
  pkg-config,
  stdenv,
  util-linuxMinimal,
  vte,
  wrapGAppsHook3,
  xmlto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "roxterm";
  version = "3.14.3";

  src = fetchFromGitHub {
    owner = "realh";
    repo = "roxterm";
    rev = finalAttrs.version;
    hash = "sha256-NSOGq3rN+9X4WA8Q0gMbZ9spO/dbZkzeo4zEno/Kgcs=";
  };

  nativeBuildInputs = [
    cmake
    libxslt
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    at-spi2-core
    dbus
    dbus-glib
    docbook_xsl
    glib
    gtk3
    harfbuzz
    libXdmcp
    libXtst
    libepoxy
    libpthreadstubs
    libselinux
    libsepol
    libtasn1
    libxkbcommon
    p11-kit
    pcre2
    util-linuxMinimal
    vte
    xmlto
  ];

  passthru.tests.test = nixosTests.terminal-emulators.roxterm;

  meta = {
    homepage = "https://github.com/realh/roxterm";
    description = " A highly configurable terminal emulator";
    longDescription = ''
      ROXTerm is a terminal emulator intended to provide similar features to
      gnome-terminal, based on the same VTE library. It was originally designed
      to have a smaller footprint and quicker start-up time by not using the
      Gnome libraries and by using a separate applet to provide the
      configuration GUI, but thanks to all the features it's acquired over the
      years ROXTerm can probably now be accused of bloat. However, it is more
      configurable than gnome-terminal and aimed more at "power" users who make
      heavy use of terminals.

      It still supports the ROX desktop application layout it was named after,
      but can also be installed in a more conventional manner for use in other
      desktop environments.
    '';
    changelog = "https://github.com/realh/roxterm/blob/${finalAttrs.src.rev}/debian/changelog";
    license = with lib.licenses; [
      gpl2Plus
      gpl3Plus
      lgpl3Plus
    ];
    mainProgram = "roxterm";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
