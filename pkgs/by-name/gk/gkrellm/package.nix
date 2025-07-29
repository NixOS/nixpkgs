{
  lib,
  stdenv,
  fetchurl,
  gettext,
  pkg-config,
  glib,
  gtk2,
  libX11,
  libSM,
  libICE,
  which,
  copyDesktopItems,
  makeDesktopItem,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gkrellm";
  version = "2.4.0";

  src = fetchurl {
    url = "http://gkrellm.srcbox.net/releases/gkrellm-${finalAttrs.version}.tar.bz2";
    hash = "sha256-b4NmV2C5Nq1LVfkYKx7HYB+vOKDyXqHkvdyZZQiPAy0=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    which
    wrapGAppsHook3
  ];

  buildInputs = [
    gettext
    glib
    gtk2
    libX11
    libSM
    libICE
  ];

  hardeningDisable = [ "format" ];

  # Makefiles are patched to fix references to `/usr/X11R6' and to add
  # `-lX11' to make sure libX11's store path is in the RPATH.
  postPatch = ''
    echo "patching makefiles..."
    for i in Makefile src/Makefile server/Makefile
    do
      sed -i "$i" -e "s|/usr/X11R6|${libX11.dev}|g ; s|-lICE|-lX11 -lICE|g"
    done
  '';

  makeFlags = [ "STRIP=-s" ];

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX=''"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "gkrellm";
      exec = "gkrellm";
      icon = "gkrellm";
      desktopName = "GKrellM";
      genericName = "System monitor";
      comment = "The GNU Krell Monitors";
      categories = [
        "System"
        "Monitor"
      ];
    })
  ];

  meta = {
    description = "Themeable process stack of system monitors";
    longDescription = ''
      GKrellM is a single process stack of system monitors which
      supports applying themes to match its appearance to your window
      manager, Gtk, or any other theme.
    '';
    homepage = "https://gkrellm.srcbox.net";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
