{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  openobex,
  bluez,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "obexftp";
  version = "0.24.2";

  src = fetchurl {
    url = "mirror://sourceforge/openobex/obexftp-${version}-Source.tar.gz";
    sha256 = "18w9r78z78ri5qc8fjym4nk1jfbrkyr789sq7rxrkshf1a7b83yl";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [ bluez ];

  propagatedBuildInputs = [ openobex ];

  postPatch = ''
    # cmake 4 compatibility, upstream is dead
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required( VERSION 3.1 FATAL_ERROR )" "cmake_minimum_required( VERSION 3.10 FATAL_ERROR )" \
      --replace-fail "cmake_policy ( VERSION 3.1 )" "cmake_policy ( VERSION 3.10 )"

    # https://sourceforge.net/p/openobex/bugs/66/
    substituteInPlace CMakeLists.txt \
      --replace-fail '\$'{prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
      --replace-fail '\$'{prefix}/'$'{CMAKE_INSTALL_INCLUDEDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR}
  '';

  # There's no such thing like "bluetooth" library; possibly they meant "bluez" but it links correctly without this.
  postFixup = ''
    sed -i 's,^Requires: bluetooth,Requires:,' $out/lib/pkgconfig/obexftp.pc
  '';

  meta = with lib; {
    homepage = "http://dev.zuckschwerdt.org/openobex/wiki/ObexFtp";
    description = "Library and tool to access files on OBEX-based devices (such as Bluetooth phones)";
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
}
