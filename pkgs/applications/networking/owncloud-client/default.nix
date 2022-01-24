{ lib, fetchurl, mkDerivation, cmake, extra-cmake-modules, pkg-config, qtbase, qtkeychain, sqlite, libsecret }:

mkDerivation rec {
  pname = "owncloud-client";
  version = "2.10.0.6519";

  src = fetchurl {
    url = "https://download.owncloud.com/desktop/ownCloud/stable/${version}/source/ownCloud-${version}.tar.xz";
    sha256 = "sha256-HDH8s/VPeOAbkyrfE7hbhePhtWcx1IUdlhDCnodomh8=";
  };

  nativeBuildInputs = [ pkg-config cmake extra-cmake-modules ];
  buildInputs = [ qtbase qtkeychain sqlite libsecret ];

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libsecret ]}"
  ];

  cmakeFlags = [
    "-UCMAKE_INSTALL_LIBDIR"
    "-DNO_SHIBBOLETH=1"
  ];

  meta = with lib; {
    description = "Synchronise your ownCloud with your computer using this desktop client";
    homepage = "https://owncloud.org";
    maintainers = [ maintainers.qknight ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
