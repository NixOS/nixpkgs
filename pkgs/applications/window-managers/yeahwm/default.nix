{ lib, stdenv, fetchurl
, lesstif
, libX11, libXext, libXmu, libXinerama }:

stdenv.mkDerivation rec {

  pname = "yeahwm";
  version = "0.3.5";

  src = fetchurl {
    url = "http://phrat.de/${pname}_${version}.tar.gz";
    sha256 = "01gfzjvb40n16m2ja4238nk08k4l203y6a61cydqvf68924fjb69";
  };

  buildInputs = [ lesstif libX11 libXext libXinerama libXmu ];

  dontConfigure = true;

  preBuild = ''
    makeFlagsArray+=( CC="${stdenv.cc}/bin/cc" \
                      XROOT="${libX11}" \
                      INCLUDES="-I${libX11.dev}/include -I${libXext.dev}/include -I${libXinerama.dev}/include -I${libXmu.dev}/include" \
                      LDPATH="-L${libX11}/lib -L${libXext}/lib -L${libXinerama}/lib -L${libXmu}/lib" \
                      prefix="${placeholder "out"}" )
  '';

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: screen.o:(.bss+0x40): multiple definition of `fg'; client.o:(.bss+0x40): first defined here
  NIX_CFLAGS_COMPILE = "-fcommon";

  postInstall = ''
    gzip -9 --stdout yeahwm.1 > yeahwm.1.gz
    install -m644 yeahwm.1.gz ${placeholder "out"}/share/man/man1/
  '';

  meta = with lib;{
    description = "An X window manager based on evilwm and aewm";
    longDescription = ''
      YeahWM is a h* window manager for X based on evilwm and aewm.

      Features
      - Sloppy Focus.
      - BeOS-like tabbed titles, which can be repositioned.
      - Support for Xinerama.
      - Simple Appearance.
      - Good keyboard control.
      - Creative usage of the mouse.
      - Respects aspect size hints.
      - Solid resize and move operations.
      - Virtual Desktops.
      - "Magic" Screen edges for desktop switching.
      - Snapping to other windows and screen borders when moving windows.
      - Small binary size(ca. 23kb).
      - Little resource usage.
      - It's slick.
    '';
    homepage = "http://phrat.de/index.html";
    license = licenses.isc;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = libX11.meta.platforms;
  };
}
