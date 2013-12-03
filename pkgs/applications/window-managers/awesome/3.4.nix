{ stdenv, fetchurl, cmake, gperf, imagemagick, pkgconfig, lua
, glib, cairo, pango, imlib2, libxcb, libxdg_basedir, xcbutil
, xcbutilimage, xcbutilkeysyms, xcbutilwm, libpthreadstubs, libXau
, libXdmcp, pixman, doxygen
, libstartup_notification, libev, asciidoc, xmlto, dbus, docbook_xsl
, docbook_xml_dtd_45, libxslt, coreutils, which }:

let
  version = "3.4.13";
in

stdenv.mkDerivation rec {
  name = "awesome-${version}";
 
  src = fetchurl {
    url = "http://awesome.naquadah.org/download/awesome-${version}.tar.xz";
    sha256 = "0jhsgb8wdzpfmdyl9fxp2w6app7l6zl8b513z3ff513nvdlxj5hr";
  };
 
  buildInputs = [ cmake gperf imagemagick pkgconfig lua glib cairo pango
    imlib2 libxcb libxdg_basedir xcbutil xcbutilimage xcbutilkeysyms xcbutilwm
    libstartup_notification libev libpthreadstubs libXau libXdmcp pixman doxygen
    asciidoc xmlto dbus docbook_xsl docbook_xml_dtd_45 libxslt which ];

  # We use coreutils for 'env', that will allow then finding 'bash' or 'zsh' in
  # the awesome lua code. I prefered that instead of adding 'bash' or 'zsh' as
  # dependencies.
  prePatch = ''
    # Fix the tab completion (supporting bash or zsh)
    sed s,/usr/bin/env,${coreutils}/bin/env, -i lib/awful/completion.lua.in
    # Remove the 'root' PATH override (I don't know why they have that)
    sed /WHOAMI/d -i utils/awsetbg
    # Russian manpages fail to be generated:
    #  [ 56%] Generating manpages/ru/man1/awesome.1.xml
    #  asciidoc: ERROR: <stdin>: line 3: name section expected
    #  asciidoc: FAILED: <stdin>: line 3: section title expected
    #  make[2]: *** [manpages/ru/man1/awesome.1.xml] Error 1
    substituteInPlace CMakeLists.txt \
      --replace "set(AWE_MAN_LANGS it es fr de ru)" \
                "set(AWE_MAN_LANGS it es fr de)"
  '';
 
  meta = {
    homepage = http://awesome.naquadah.org/;
    description = "Highly configurable, dynamic window manager for X";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
