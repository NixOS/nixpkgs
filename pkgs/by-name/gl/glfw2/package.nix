{
  lib,
  stdenv,
  fetchurl,
  libGLU,
  libGL,
  libX11,
  libXext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glfw";
  version = "2.7.9";

  src = fetchurl {
    url = "mirror://sourceforge/glfw/glfw-${finalAttrs.version}.tar.bz2";
    sha256 = "17c2msdcb7pn3p8f83805h1c216bmdqnbn9hgzr1j8wnwjcpxx6i";
  };

  buildInputs = [
    libGLU
    libGL
    libX11
    libXext
  ];

  buildPhase = ''
    make x11
  '';

  installPhase = ''
    mkdir -p $out
    make x11-dist-install PREFIX=$out
    mv $out/lib/libglfw.so $out/lib/libglfw.so.2
    ln -s libglfw.so.2 $out/lib/libglfw.so
  '';

  meta = {
    description = "Multi-platform library for creating OpenGL contexts and managing input, including keyboard, mouse, joystick and time";
    homepage = "https://glfw.sourceforge.net/";
    license = lib.licenses.zlib;
    maintainers = [ lib.maintainers.marcweber ];
    platforms = lib.platforms.linux;
  };
})
