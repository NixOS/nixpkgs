{ stdenv, fetchurl
, pkgconfig, libtool
, gtk2, libGLU_combined, readline, libX11, libXpm
, docbook_xml_dtd_45, docbook_xsl
, sdlSupport ? true, SDL2 ? null
, termSupport ? true, ncurses ? null
, wxSupport ? true, wxGTK ? null
, wgetSupport ? false, wget ? null
, curlSupport ? false, curl ? null
}:

assert sdlSupport -> (SDL2 != null);
assert termSupport -> (ncurses != null);
assert wxSupport -> (gtk2 != null && wxGTK != null);
assert wgetSupport -> (wget != null);
assert curlSupport -> (curl != null);

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "bochs-${version}";
  version = "2.6.9";

  src = fetchurl {
    url = "mirror://sourceforge/project/bochs/bochs/${version}/${name}.tar.gz";
    sha256 = "1379cq4cnfprhw8mgh60i0q9j8fz8d7n3d5fnn2g9fdiv5znfnzf";
  };

  patches = [ ./bochs-2.6.9-glibc-2.26.patch ];

  buildInputs = with stdenv.lib;
  [ pkgconfig libtool gtk2 libGLU_combined readline libX11 libXpm docbook_xml_dtd_45 docbook_xsl ]
  ++ optionals termSupport [ ncurses ]
  ++ optionals sdlSupport [ SDL2 ]
  ++ optionals wxSupport [ wxGTK ]
  ++ optionals wgetSupport [ wget ]
  ++ optionals curlSupport [ curl ];

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
    "--enable-raw-serial=no" ]
    # Boolean flags
    ++ optionals termSupport [ "--with-term" ]
    ++ optionals sdlSupport [ "--with-sdl2" ]
    ++ optionals wxSupport [ "--with-wx" ]
    # These are completely configurable, and they don't depend of external tools
    ++ [ "--enable-cpu-level=6" # from 3 to 6
         "--enable-largefile"
         "--enable-idle-hack"
         "--enable-plugins=no" # Plugins are a bit buggy in Bochs
         "--enable-a20-pin"
         "--enable-x86-64"
         "--enable-smp"
         "--enable-large-ramfile"
         "--enable-repeat-speedups"
         "--enable-handlers-chaining"
         "--enable-trace-linking"
         "--enable-configurable-msrs"
         "--enable-show-ips"
         "--enable-debugger" #conflicts with gdb-stub option
         "--enable-disasm"
         "--enable-debugger-gui"
         "--enable-gdb-stub=no" # conflicts with debugger option
         "--enable-iodebug"
         "--enable-fpu"
         "--enable-svm"
         "--enable-avx"
         "--enable-evex"
         "--enable-x86-debugger"
         "--enable-pci"
         "--enable-usb"
         "--enable-usb-ohci"
         "--enable-usb-ehci"
         "--enable-usb-xhci"
         "--enable-ne2000"
         "--enable-pnic"
         "--enable-e1000"
         "--enable-clgd54xx"
         "--enable-voodoo"
         "--enable-cdrom"
         "--enable-sb16"
         "--enable-es1370"
         "--enable-busmouse" ];

  NIX_CFLAGS_COMPILE="-I${gtk2.dev}/include/gtk-2.0/ -I${libtool}/include/";
  NIX_LDFLAGS="-L${libtool.lib}/lib";

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  meta = {
    description = "An open-source IA-32 (x86) PC emulator";
    longDescription = ''
      Bochs is an open-source (LGPL), highly portable IA-32 PC emulator, written
      in C++, that runs on most popular platforms. It includes emulation of the
      Intel x86 CPU, common I/O devices, and a custom BIOS.
    '';
    homepage = http://bochs.sourceforge.net/;
    license = licenses.lgpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
# TODO: plugins
# TODO: svga support - the Bochs sources explicitly cite /usr/include/vga.h
# TODO: a better way to organize the options
