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

stdenv.mkDerivation rec {
  pname = "bochs";
  version = "2.6.11";

  src = fetchurl {
    url = "mirror://sourceforge/project/bochs/bochs/${version}/${pname}-${version}.tar.gz";
    sha256 = "0ql8q6y1k356li1g9gbvl21448mlxphxxi6kjb2b3pxvzd0pp2b3";
  };

  patches = [
    # A flip between two lines of code, in order to compile with GLIBC 2.26
    ./bochs-2.6.11-glibc-2.26.patch
    # Fix compilation for MSYS2 GCC 10; remove it when the next version arrives
    ./bochs_fix_narrowing_conv_warning.patch
    # SMP-enabled configs; remove it when the next version arrives
    ./fix-build-smp.patch
  ];

  nativeBuildInputs = [
    docbook_xml_dtd_45
    docbook_xsl
    pkg-config
  ];
  buildInputs = [
    SDL2
    curl
    gtk2
    libGL
    libtool
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
    "--with-svga=no" # it doesn't compile on NixOS

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
    "--enable-disasm"
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
    "--enable-plugins=no" # Plugins are a bit buggy in Bochs
    "--enable-pnic"
    "--enable-repeat-speedups"
    "--enable-sb16"
    "--enable-show-ips"
    "--enable-smp"
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

  NIX_CFLAGS_COMPILE="-I${gtk2.dev}/include/gtk-2.0/ -I${libtool}/include/";
  NIX_LDFLAGS="-L${libtool.lib}/lib";

  hardeningDisable = [ "format" ];

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
  };
}
# TODO: plugins
# TODO: a better way to organize the options
