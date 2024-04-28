{
  lib,
  SDL2,
  curl,
  darwin,
  docbook_xml_dtd,
  docbook_xsl,
  fetchFromGitHub,
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
  wxGTK,
  # Boolean flags
  enableSDL2 ? true,
  enableTerm ? true,
  enableWx ? !stdenv.isDarwin,
  enableX11 ? !stdenv.isDarwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bochs";
  version = "2.8";

  src = fetchFromGitHub {
    owner = "bochs-emu";
    repo = "Bochs";
    rev = "REL_${lib.replaceStrings ["."] [ "_" ] finalAttrs.version}_FINAL";
    hash = "sha256-Xnw5h8/pxzAXmGxPUmlUB6iUulTsPJcXsdGA1KN9FaQ=";
  };

  nativeBuildInputs = [
    docbook_xml_dtd
    docbook_xsl
    libtool
    pkg-config
  ]
  ++ lib.optionals enableSDL2 [
    SDL2
  ];

  buildInputs = [
    curl
    readline
    wget
  ] ++ lib.optionals enableSDL2 [
    SDL2
  ] ++ lib.optionals enableTerm [
    ncurses
  ] ++ lib.optionals enableWx [
    gtk3
    wxGTK
  ] ++ lib.optionals enableX11 [
    libGL
    libGLU
    libX11
    libXpm
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.libobjc
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

    # Dangerous options - they are marked as "incomplete/experimental" on Bochs documentation
    (lib.enableFeature false "3dnow")
    (lib.enableFeature false "monitor-mwait")
    (lib.enableFeature false "raw-serial")

    # These are completely configurable, and they don't depend of external tools
    (lib.enableFeatureAs true "cpu-level" "6") # from 3 to 6
    (lib.enableFeatureAs true "vmx" "2")

    (lib.enableFeature false "gdb-stub") # conflicts with debugger option
    (lib.enableFeature true "debugger") #conflicts with gdb-stub option

    (lib.enableFeature true "a20-pin")
    (lib.enableFeature true "avx")
    (lib.enableFeature true "busmouse")
    (lib.enableFeature true "cdrom")
    (lib.enableFeature true "clgd54xx")
    (lib.enableFeature true "configurable-msrs")
    (lib.enableFeature true "debugger-gui")
    (lib.enableFeature true "evex")
    (lib.enableFeature true "fpu")
    (lib.enableFeature true "handlers-chaining")
    (lib.enableFeature true "idle-hack")
    (lib.enableFeature true "iodebug")
    (lib.enableFeature true "large-ramfile")
    (lib.enableFeature true "largefile")
    (lib.enableFeature true "pci")
    (lib.enableFeature true "repeat-speedups")
    (lib.enableFeature true "show-ips")
    (lib.enableFeature true "smp")
    (lib.enableFeature true "svm")
    (lib.enableFeature true "trace-linking")
    (lib.enableFeature true "usb")
    (lib.enableFeature true "usb-ehci")
    (lib.enableFeature true "usb-ohci")
    (lib.enableFeature true "usb-xhci")
    (lib.enableFeature true "voodoo")
    (lib.enableFeature true "x86-64")
    (lib.enableFeature true "x86-debugger")

    (lib.withFeature enableSDL2 "sdl2")
    (lib.withFeature enableTerm "term")
    (lib.withFeature enableWx "wx")
    (lib.withFeature enableX11 "x")
    (lib.withFeature enableX11 "x11")

    (lib.enableFeature (!stdenv.isDarwin) "e1000")
    (lib.enableFeature (!stdenv.isDarwin) "es1370")
    (lib.enableFeature (!stdenv.isDarwin) "ne2000")
    (lib.enableFeature (!stdenv.isDarwin) "plugins")
    (lib.enableFeature (!stdenv.isDarwin) "pnic")
    (lib.enableFeature (!stdenv.isDarwin) "sb16")
  ];

  # No lib output or else Darwin cries
  outputs = [ "out" "doc" "man" ];

  enableParallelBuilding = true;

  strictDeps = true;

  sourceRoot = "${finalAttrs.src.name}/bochs";

  meta = {
    homepage = "https://bochs.sourceforge.io/";
    description = "An open-source IA-32 (x86) PC emulator";
    longDescription = ''
      Bochs is an open-source (LGPL), highly portable IA-32 PC emulator, written
      in C++, that runs on most popular platforms. It includes emulation of the
      Intel x86 CPU, common I/O devices, and a custom BIOS.
    '';
    license = lib.licenses.lgpl2Plus;
    mainProgram = "bochs";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
# TODO: investigate autoreconfHook errors
# TODO: docbook (docbook-tools from RedHat mirrors should help)
