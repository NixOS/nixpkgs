{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxext,
  libx11,
  xorgproto,
  mesa,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvdpau";
  version = "1.5";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/vdpau/libvdpau/-/archive/${finalAttrs.version}/libvdpau-${finalAttrs.version}.tar.bz2";
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
  buildInputs = [
    xorgproto
    libxext
  ];

  propagatedBuildInputs = [ libx11 ];

  mesonFlags = lib.optionals stdenv.hostPlatform.isLinux [
    "-Dmoduledir=${mesa.driverLink}/lib/vdpau"
  ];

  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-lX11";

  # The tracing library in this package must be conditionally loaded with dlopen().
  # Therefore, we must restore the RPATH entry for the library itself that was removed by the patchelf hook.
  postFixup = lib.optionalString stdenv.hostPlatform.isElf ''
    patchelf $out/lib/libvdpau.so --add-rpath $out/lib
  '';

  meta = {
    homepage = "https://www.freedesktop.org/wiki/Software/VDPAU/";
    description = "Library to use the Video Decode and Presentation API for Unix (VDPAU)";
    license = lib.licenses.mit; # expat version
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.vcunat ];
  };
})
