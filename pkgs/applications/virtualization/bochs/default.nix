{ stdenv, fetchurl, config
, pkgconfig, libtool
, gtk, mesa, readline, libX11, libXpm
, docbook_xml_dtd_45, docbook_xsl
, sdlSupport ? true, SDL2 ? null
, termSupport ? true , ncurses ? null
, wxSupport ? true, wxGTK ? null
# Optional, undocumented dependencies
, wgetSupport ? false, wget ? null
, curlSupport ? false, curl ? null
}:

assert sdlSupport -> (SDL2 != null);
assert termSupport -> (ncurses != null);
assert wxSupport -> (gtk != null && wxGTK != null);
assert wgetSupport -> (wget != null);
assert curlSupport -> (curl != null);

stdenv.mkDerivation rec {

  name = "bochs-${version}";
  version = "2.6.8";

  src = fetchurl {
    url = "mirror://sourceforge/project/bochs/bochs/${version}/${name}.tar.gz";
    sha256 = "1kl5cmbz6qgg33j5vv9898nzdppp1rqgy24r5pv762aaj7q0ww3r";
  };

  # The huge list of configurable options
  # Blatantly based on ffmpeg expressions

  termSupport = config.bochs.termSupport or true;
  sdlSupport = config.bochs.sdlSupport or true;
  wxSupport = config.bochs.wxSupport or false;
  largefile = config.bochs.largefile or true;
  idleHack = config.bochs.idleHack or true;
  plugins = config.bochs.plugins or false; # Warning! Broken
  a20Pin = config.bochs.a20Pin or true;
  emulate64Bits = config.bochs.emulate64Bits or false;
  smp = config.bochs.smp or false;
  largeRamfile = config.bochs.largeRamfile or true;
  repeatSpeedups = config.bochs.repeatSpeedups or false;
  handlersChaining = config.bochs.handlersChaining or false;
  traceLinking = config.bochs.traceLinking or false;
  configurableMSRegs = config.bochs.configurableMSRegs or false;
  showIPS = config.bochs.showIPS or true;
  debugger = config.bochs.debugger or false;
  disasm = config.bochs.disasm or false;
  debuggerGui = config.bochs.debuggerGui or false;
  gdbStub = config.bochs.gdbStub or false;
  IODebug = config.Bochs.IODebug or false;
  fpu = config.bochs.fpu or true;
  svm = config.bochs.svm or false;
  avx = config.bochs.avx or false;
  evex = config.bochs.evex or false;
  x86Debugger = config.bochs.x86Debugger or false;
  pci = config.bochs.pci or true;
  uhci = config.bochs.uhci or false;
  ohci = config.bochs.ohci or false;
  ne2k = config.bochs.ne2k or true;
  pNIC = config.bochs.pNIC or true;
  e1000 = config.bochs.e1000 or true;
  clgd54xx = config.bochs.clgd54xx or true;
  voodoo = config.bochs.voodoo or true;
  cdrom = config.bochs.cdrom or true;
  sb16 = config.bochs.sb16 or true;
  es1370 = config.bochs.es1370 or true;
  gameport = config.bochs.gameport or true;
  busMouse = config.bochs.busMouse or false;

  buildInputs = with stdenv.lib;
  [ pkgconfig libtool gtk mesa readline libX11 libXpm docbook_xml_dtd_45 docbook_xsl ]
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
    "--with-wx=no"

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
    "--enable-usb-xhci=no"
    "--enable-monitor-mwait=no"
    "--enable-raw-serial=no" ]
    # Boolean flags
    ++ stdenv.lib.optional termSupport "--with-term"
    ++ stdenv.lib.optional sdlSupport "--with-sdl2"
    ++ stdenv.lib.optional wxSupport "--with-wx"
    ++ stdenv.lib.optional largefile "--enable-largefile"
    ++ stdenv.lib.optional idleHack "--enable-idle-hack"
    ++ stdenv.lib.optional plugins "--enable-plugins"
    ++ stdenv.lib.optional a20Pin "--enable-a20-pin"
    ++ stdenv.lib.optional emulate64Bits "--enable-x86-64"
    ++ stdenv.lib.optional smp "--enable-smp"
    ++ stdenv.lib.optional largeRamfile "--enable-large-ramfile"
    ++ stdenv.lib.optional repeatSpeedups "--enable-repeat-speedups"
    ++ stdenv.lib.optional handlersChaining "--enable-handlers-chaining"
    ++ stdenv.lib.optional traceLinking "--enable-trace-linking"
    ++ stdenv.lib.optional configurableMSRegs "--enable-configurable-msrs"
    ++ stdenv.lib.optional showIPS "--enable-show-ips"
    ++ stdenv.lib.optional debugger "--enable-debugger"
    ++ stdenv.lib.optional disasm "--enable-disasm"
    ++ stdenv.lib.optional debuggerGui "--enable-debugger-gui"
    ++ stdenv.lib.optional gdbStub "--enable-gdb-stub"
    ++ stdenv.lib.optional IODebug "--enable-iodebug"
    ++ stdenv.lib.optional fpu "--enable-fpu"
    ++ stdenv.lib.optional svm "--enable-svm"
    ++ stdenv.lib.optional avx "--enable-avx"
    ++ stdenv.lib.optional evex "--enable-evex"
    ++ stdenv.lib.optional x86Debugger "--enable-x86-debugger"
    ++ stdenv.lib.optional pci "--enable-pci"
    ++ stdenv.lib.optional uhci "--enable-usb"
    ++ stdenv.lib.optional ohci "--enable-usb-ohci"
    ++ stdenv.lib.optional ne2k "--enable-ne2000"
    ++ stdenv.lib.optional pNIC "--enable-pnic"
    ++ stdenv.lib.optional e1000 "--enable-e1000"
    ++ stdenv.lib.optional clgd54xx "--enable-clgd54xx"
    ++ stdenv.lib.optional voodoo "--enable-voodoo"
    ++ stdenv.lib.optional cdrom "--enable-cdrom"
    ++ stdenv.lib.optional sb16 "--enable-sb16"
    ++ stdenv.lib.optional es1370 "--enable-es1370"
    ++ stdenv.lib.optional busMouse "--enable-busmouse"
    ;

  NIX_CFLAGS_COMPILE="-I${gtk.dev}/include/gtk-2.0/ -I${libtool}/include/";
  NIX_LDFLAGS="-L${libtool.lib}/lib";

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "An open-source IA-32 (x86) PC emulator";
    longDescription = ''
    Bochs is an open-source (LGPL), highly portable IA-32 PC emulator,
    written in C++, that runs on most popular platforms. It includes
    emulation of the Intel x86 CPU, common I/O devices, and a custom
    BIOS.
    '';
    homepage = http://bochs.sourceforge.net/;
    license = licenses.lgpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}

# TODO: study config.bochs.* implementation (like config.ffmpeg.* options)
# TODO: investigate the wxWidgets problem (maybe upstream devteam didn't update wxGTK GUI)
# TODO: investigate svga support - the Bochs sources explicitly cite /usr/include/svga.h
