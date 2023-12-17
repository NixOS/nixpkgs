{ lib
, stdenv
, fetchFromGitHub
, SDL2
, curl
, darwin
, docbook_xml_dtd_45
, docbook_xsl
, gtk3
, libGL
, libGLU
, libX11
, libXpm
, libtool
, ncurses
, pkg-config
, readline
, wget
, wxGTK32
, enableSDL2 ? true
, enableTerm ? true
, enableWx ? false # Too heavy
, enableX11 ? !stdenv.isDarwin
}:

assert enableWx -> !stdenv.isDarwin;
stdenv.mkDerivation (finalAttrs: {
  pname = "bochs";
  version = "2.7-unstable-2023-12-16";

  src = fetchFromGitHub {
    owner = "bochs-emu";
    repo = "Bochs";
    rev = "54831068df334989405f16f85117f7f46fef944d";
    hash = "sha256-iZ3HN1Ysi8VAAL4rfDqS3YppdgkJ3soKy7ZAjesoyKE=";
  };

  sourceRoot = "${finalAttrs.src.name}/bochs";

  nativeBuildInputs = [
    docbook_xml_dtd_45
    docbook_xsl
    libtool
    pkg-config
  ] ++ lib.optionals enableSDL2 [
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
    wxGTK32
  ] ++ lib.optionals enableX11 [
    libGL
    libGLU
    libX11
    libXpm
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.libobjc
  ];

  outputs = [ "out" "lib" "man" ];

  strictDeps = true;

  configureFlags = [
    (lib.withFeature false "rfb")
    (lib.withFeature false "vncsrv")
    (lib.withFeature false "nogui")

    # These will always be "true" on NixOS
    (lib.enableFeature true "ltdl-install")
    (lib.enableFeature true "readline")
    (lib.enableFeature true "all-optimizations")
    (lib.enableFeature true "logging")
    (lib.enableFeature true "xpm")

    # ... whereas these, always "false"
    (lib.enableFeature false "cpp")
    (lib.enableFeature false "instrumentation")

    # Broken - it requires docbook2html
    (lib.enableFeature false "docbook")

    # Dangerous options - they are marked as "incomplete/experimental" on Bochs
    # documentation
    (lib.enableFeature false "3dnow")
    (lib.enableFeature false "monitor-mwait")
    (lib.enableFeature false "raw-serial")

    # These are completely configurable, and they don't depend of external tools
    (lib.enableFeature true "a20-pin")
    (lib.enableFeature true "avx")
    (lib.enableFeature true "busmouse")
    (lib.enableFeature true "cdrom")
    (lib.enableFeature true "clgd54xx")
    (lib.enableFeature true "configurable-msrs")
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
    (lib.enableFeature true "svm")
    (lib.enableFeature true "trace-linking")
    (lib.enableFeature true "usb")
    (lib.enableFeature true "usb-ehci")
    (lib.enableFeature true "usb-ohci")
    (lib.enableFeature true "usb-xhci")
    (lib.enableFeature true "voodoo")
    (lib.enableFeature true "x86-64")
    (lib.enableFeature true "x86-debugger")

    (lib.enableFeature (!stdenv.isDarwin) "e1000")
    (lib.enableFeature (!stdenv.isDarwin) "es1370")
    (lib.enableFeature (!stdenv.isDarwin) "ne2000")
    (lib.enableFeature (!stdenv.isDarwin) "plugins")
    (lib.enableFeature (!stdenv.isDarwin) "pnic")
    (lib.enableFeature (!stdenv.isDarwin) "sb16")

    (lib.enableFeatureAs true "cpu-level" "6")
    (lib.enableFeatureAs true "vmx" "2")

    (lib.withFeature enableSDL2 "sdl2")
    (lib.withFeature enableTerm "term")
    (lib.withFeature enableWx "wx")
    (lib.withFeature enableX11 "x")
    (lib.withFeature enableX11 "x11")
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://bochs.sourceforge.io/";
    description = "An open-source IA-32 (x86) PC emulator";
    longDescription = ''
      Bochs is an open-source (LGPL), highly portable IA-32 PC emulator, written
      in C++, that runs on most popular platforms. It includes emulation of the
      Intel x86 CPU, common I/O devices, and a custom BIOS.
    '';
    license = with lib.licenses; [ lgpl2Plus ];
    mainProgram = "bochs";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
# TODO: docbook (docbook-tools from RedHat mirrors should help)
