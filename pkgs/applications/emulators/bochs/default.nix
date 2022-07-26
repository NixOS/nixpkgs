{ lib
, stdenv
, fetchurl
, SDL2
, curl
, docbook_xml_dtd_45
, docbook_xsl
, gtk2
, libGL
, libGLU
, libX11
, libXpm
, libtool
, ncurses
, pkg-config
, readline
, wget
, wxGTK
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bochs";
  version = "2.7";

  src = fetchurl {
    url = "mirror://sourceforge/project/${finalAttrs.pname}/${finalAttrs.pname}/${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-oBCrG/3HKsWgjS4kEs1HHA/r1mrx2TSbwNeWh53lsXo=";
  };

  nativeBuildInputs = [
    docbook_xml_dtd_45
    docbook_xsl
    libtool
    pkg-config
  ];

  buildInputs = [
    SDL2
    curl
    gtk2
    libGL
    libGLU
    libX11
    libXpm
    ncurses
    readline
    wget
    wxGTK
  ];

  configureFlags = [
    "--with-x=yes"
    "--with-x11=yes"

    "--with-rfb=no"
    "--with-vncsrv=no"
    "--with-nogui"

    # These will always be "yes" on NixOS
    "--enable-ltdl-install=yes"
    "--enable-readline=yes"
    "--enable-all-optimizations=yes"
    "--enable-logging=yes"
    "--enable-xpm=yes"

    # ... whereas these, always "no"!
    "--enable-cpp=no"
    "--enable-instrumentation=no"

    "--enable-docbook=no" # Broken - it requires docbook2html

    # Dangerous options - they are marked as "incomplete/experimental" on Bochs documentation
    "--enable-3dnow=no"
    "--enable-monitor-mwait=no"
    "--enable-raw-serial=no"

    # These are completely configurable, and they don't depend of external tools
    "--enable-a20-pin"
    "--enable-avx"
    "--enable-busmouse"
    "--enable-cdrom"
    "--enable-clgd54xx"
    "--enable-configurable-msrs"
    "--enable-cpu-level=6" # from 3 to 6
    "--enable-debugger" #conflicts with gdb-stub option
    "--enable-debugger-gui"
    "--enable-e1000"
    "--enable-es1370"
    "--enable-evex"
    "--enable-fpu"
    "--enable-gdb-stub=no" # conflicts with debugger option
    "--enable-handlers-chaining"
    "--enable-idle-hack"
    "--enable-iodebug"
    "--enable-large-ramfile"
    "--enable-largefile"
    "--enable-ne2000"
    "--enable-pci"
    "--enable-plugins=yes"
    "--enable-pnic"
    "--enable-repeat-speedups"
    "--enable-sb16"
    "--enable-show-ips"
    "--enable-smp"
    "--enable-vmx=2"
    "--enable-svm"
    "--enable-trace-linking"
    "--enable-usb"
    "--enable-usb-ehci"
    "--enable-usb-ohci"
    "--enable-usb-xhci"
    "--enable-voodoo"
    "--enable-x86-64"
    "--enable-x86-debugger"
  ]
  # Boolean flags
  ++ lib.optionals (SDL2 != null) [ "--with-sdl2" ]
  ++ lib.optionals (ncurses != null) [ "--with-term" ]
  ++ lib.optionals (gtk2 != null && wxGTK != null) [ "--with-wx" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://bochs.sourceforge.io/";
    description = "An open-source IA-32 (x86) PC emulator";
    longDescription = ''
      Bochs is an open-source (LGPL), highly portable IA-32 PC emulator, written
      in C++, that runs on most popular platforms. It includes emulation of the
      Intel x86 CPU, common I/O devices, and a custom BIOS.
    '';
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
})
# TODO: a better way to organize the options
# TODO: docbook (docbook-tools from RedHat mirrors should help)
