{
  lib,
  stdenv,
  fetchurl,
  unzip,
  xorg,
  libGLU,
  libGL,
}:

stdenv.mkDerivation rec {
  pname = "AntTweakBar";
  version = "1.16";

  nativeBuildInputs = [ unzip ];
  buildInputs = [
    xorg.libX11
    libGLU
    libGL
  ];

  src = fetchurl {
    url = "mirror://sourceforge/project/anttweakbar/AntTweakBar_${
      lib.replaceStrings [ "." ] [ "" ] version
    }.zip";
    sha256 = "0z3frxpzf54cjs07m6kg09p7nljhr7140f4pznwi7srwq4cvgkpv";
  };

  postPatch = "cd src";
  installPhase = ''
    mkdir -p $out/lib/
    cp ../lib/{libAntTweakBar.so,libAntTweakBar.so.1,libAntTweakBar.a} $out/lib/
    cp -r ../include $out/
  '';

  meta = {
    description = "Add a light/intuitive GUI to OpenGL applications";
    longDescription = ''
      A small and easy-to-use C/C++ library that allows to quickly add a light
      and intuitive graphical user interface into graphic applications based on OpenGL
      (compatibility and core profiles), DirectX 9, DirectX 10 or DirectX 11
      to interactively tweak parameters on-screen
    '';
    homepage = "https://anttweakbar.sourceforge.net/";
    license = lib.licenses.zlib;
    maintainers = [ lib.maintainers.razvan ];
    platforms = lib.platforms.linux;
  };
}
