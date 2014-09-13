{ stdenv, fetchurl, pkgconfig, libX11, libXft, libXmu }:

stdenv.mkDerivation rec {
  name = "windowmaker-${version}";
  version = "0.95.5";
  srcName = "WindowMaker-${version}";

  src = fetchurl {
    url = "http://windowmaker.org/pub/source/release/${srcName}.tar.gz";
    sha256 = "1l3hmx4jzf6vp0zclqx9gsqrlwh4rvqm1g1zr5ha0cp0zmsg89ab";
  };

  buildInputs = [ pkgconfig libX11 libXft libXmu ];

  meta = with stdenv.lib; {
    homepage = http://windowmaker.org/;
    description = "NeXTSTEP-like window manager";
    longDescription = ''
      Window Maker is an X11 window manager originally designed to
      provide integration support for the GNUstep Desktop
      Environment. In every way possible, it reproduces the elegant look
      and feel of the NEXTSTEP user interface. It is fast, feature rich,
      easy to configure, and easy to use. It is also free software, with
      contributions being made by programmers from around the world.
    '';
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
