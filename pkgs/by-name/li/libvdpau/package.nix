{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorg,
  mesa,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "libvdpau";
  version = "1.5";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/vdpau/libvdpau/-/archive/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-pdUKQrjCiP68BxUatkOsjeBqGERpZcckH4m06BCCGRM=";
  };
  patches = [ ./tracing.patch ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = with xorg; [
    xorgproto
    libXext
  ];

  propagatedBuildInputs = [ xorg.libX11 ];

  mesonFlags = lib.optionals stdenv.hostPlatform.isLinux [
    "-Dmoduledir=${mesa.driverLink}/lib/vdpau"
  ];

  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-lX11";

  # The tracing library in this package must be conditionally loaded with dlopen().
  # Therefore, we must restore the RPATH entry for the library itself that was removed by the patchelf hook.
  postFixup = lib.optionalString stdenv.hostPlatform.isElf ''
    patchelf $out/lib/libvdpau.so --add-rpath $out/lib
  '';

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/VDPAU/";
    description = "Library to use the Video Decode and Presentation API for Unix (VDPAU)";
    license = licenses.mit; # expat version
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
