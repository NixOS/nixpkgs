{
  stdenv
, fetchFromGitHub
, fetchpatch
, fetchurl
, fetchzip
, freetype
, jansson
, lib
, libGL
, libX11
, libXcursor
, libXext
, libXrandr
, libarchive
, liblo
, libsamplerate
, mesa
, pkg-config
, python3
, speexdsp
}:

stdenv.mkDerivation rec {
  pname = "cardinal";
  version = "22.04";

  src = fetchurl {
    url =
      "https://github.com/DISTRHO/Cardinal/releases/download/${version}/cardinal-${version}.tar.xz";
    sha256 = "sha256-7As4CckwByrTynOOpwAXa1R9Bpp/ft537f+PvAgz/BE=";
  };

  prePatch = ''
    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    freetype
    jansson
    libGL
    libX11
    libXcursor
    libXext
    libXrandr
    libXrandr
    libarchive
    liblo
    libsamplerate
    mesa
    python3
    speexdsp
  ];

  makeFlags = [ "SYSDEPS=true" "PREFIX=$(out)" ];

  meta = {
    description = "Plugin wrapper around VCV Rack";
    homepage = "https://github.com/DISTRHO/cardinal";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.all;
    # ../../utils/CarlaPluginUI.cpp:31:10: fatal error: 'Cocoa/Cocoa.h' file not found
    # # import <Cocoa/Cocoa.h>
    broken = stdenv.isDarwin;
  };
}
