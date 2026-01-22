{
  lib,
  SDL2,
  curl,
  docbook_xml_dtd_45,
  docbook_xsl,
  fetchurl,
  gtk3,
  libGL,
  libGLU,
  libX11,
  libXpm,
  libtool,
  ncurses,
  pkg-config,
  readline,
  stdenv,
  wget,
  wxGTK32,
  # Boolean flags
  enableSDL2 ? true,
  enableTerm ? true,
  enableWx ? !stdenv.hostPlatform.isDarwin,
  enableX11 ? !stdenv.hostPlatform.isDarwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bochs";
  version = "3.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/bochs/bochs/${finalAttrs.version}/bochs-${finalAttrs.version}.tar.gz";
    hash = "sha256-y29UK1HzWizJIGsqmA21YCt80bfPLk7U8Ras1VB3gao=";
  };
  # Fix build on darwin, remove on next version
  # https://sourceforge.net/p/bochs/bugs/1466/
  patches = lib.optional stdenv.hostPlatform.isDarwin ./fix-darwin-build.patch;

  nativeBuildInputs = [
    docbook_xml_dtd_45
    docbook_xsl
    libtool
    pkg-config
  ];

  buildInputs = [
    curl
    readline
    wget
  ]
  ++ lib.optionals enableSDL2 [
    SDL2
  ]
  ++ lib.optionals enableTerm [
    ncurses
  ]
  ++ lib.optionals enableWx [
    gtk3
    wxGTK32
  ]
  ++ lib.optionals enableX11 [
    libGL
    libGLU
    libX11
    libXpm
  ];

  configureFlags = [
    (lib.withFeature false "rfb")
    (lib.withFeature false "vncsrv")
    (lib.withFeature true "nogui")

    # These will always be "yes" on NixOS
    (lib.enableFeature true "ltdl-install")
    (lib.enableFeature true "readline")
    (lib.enableFeature true "all-optimizations")
    (lib.enableFeature true "logging")
    (lib.enableFeature true "xpm")

    # ... whereas these, always "no"!
    (lib.enableFeature false "cpp")
    (lib.enableFeature false "instrumentation")

    (lib.enableFeature false "docbook") # Broken - it requires docbook2html

    # These are completely configurable, and they don't depend of external tools
    (lib.enableFeature true "a20-pin")
    (lib.enableFeature true "avx")
    (lib.enableFeature true "busmouse")
    (lib.enableFeature true "cdrom")
    (lib.enableFeature true "clgd54xx")
    (lib.enableFeature true "configurable-msrs")
    (lib.enableFeatureAs true "cpu-level" "6") # from 3 to 6
    (lib.enableFeature true "debugger") # conflicts with gdb-stub option
    (lib.enableFeature true "debugger-gui")
    (lib.enableFeature true "evex")
    (lib.enableFeature true "fpu")
    (lib.enableFeature false "gdb-stub") # conflicts with debugger option
    (lib.enableFeature true "handlers-chaining")
    (lib.enableFeature true "idle-hack")
    (lib.enableFeature true "iodebug")
    (lib.enableFeature true "large-ramfile")
    (lib.enableFeature true "largefile")
    (lib.enableFeature true "pci")
    (lib.enableFeature true "repeat-speedups")
    (lib.enableFeature true "show-ips")
    (lib.enableFeature true "smp")
    (lib.enableFeatureAs true "vmx" "2")
    (lib.enableFeature true "svm")
    (lib.enableFeature true "trace-linking")
    (lib.enableFeature true "usb")
    (lib.enableFeature true "usb-ehci")
    (lib.enableFeature true "usb-ohci")
    (lib.enableFeature true "usb-xhci")
    (lib.enableFeature true "voodoo")
    (lib.enableFeature true "x86-64")
    (lib.enableFeature true "x86-debugger")
  ]
  ++ lib.optionals enableSDL2 [
    (lib.withFeature true "sdl2")
  ]
  ++ lib.optionals enableTerm [
    (lib.withFeature true "term")
  ]
  ++ lib.optionals enableWx [
    (lib.withFeature true "wx")
  ]
  ++ lib.optionals enableX11 [
    (lib.withFeature true "x")
    (lib.withFeature true "x11")
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    (lib.enableFeature true "e1000")
    (lib.enableFeature true "es1370")
    (lib.enableFeature true "ne2000")
    (lib.enableFeature true "plugins")
    (lib.enableFeature true "pnic")
    (lib.enableFeature true "sb16")
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://bochs.sourceforge.io/";
    description = "Open-source IA-32 (x86) PC emulator";
    longDescription = ''
      Bochs is an open-source (LGPL), highly portable IA-32 PC emulator, written
      in C++, that runs on most popular platforms. It includes emulation of the
      Intel x86 CPU, common I/O devices, and a custom BIOS.
    '';
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ patrickdag ];
    platforms = lib.platforms.unix;
  };
})
# TODO: a better way to organize the options
# TODO: docbook (docbook-tools from RedHat mirrors should help)
