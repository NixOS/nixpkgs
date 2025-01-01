{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  bluez,
  libusb-compat-0_1,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "openobex";
  version = "1.7.2";

  src = fetchurl {
    url = "mirror://sourceforge/openobex/openobex-${version}-Source.tar.gz";
    sha256 = "1z6l7pbwgs5pjx3861cyd3r6vq5av984bdp4r3hgrw2jxam6120m";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  buildInputs = [
    bluez
    libusb-compat-0_1
  ];

  configureFlags = [ "--enable-apps" ];

  patchPhase = ''
    sed -i "s!/lib/udev!$out/lib/udev!" udev/CMakeLists.txt
    sed -i "/if ( PKGCONFIG_UDEV_FOUND )/,/endif ( PKGCONFIG_UDEV_FOUND )/d" udev/CMakeLists.txt
    # https://sourceforge.net/p/openobex/bugs/66/
    substituteInPlace CMakeLists.txt \
      --replace '\$'{prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
      --replace '\$'{prefix}/'$'{CMAKE_INSTALL_INCLUDEDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR}
  '';

  meta = with lib; {
    homepage = "http://dev.zuckschwerdt.org/openobex/";
    description = "Open source implementation of the Object Exchange (OBEX) protocol";
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
    mainProgram = "obex-check-device";
  };
}
