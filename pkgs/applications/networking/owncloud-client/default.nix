{ lib, fetchurl, mkDerivation, cmake, extra-cmake-modules, pkg-config, qtbase, qtkeychain, sqlite, libsecret }:

mkDerivation rec {
  pname = "owncloud-client";
  version = "2.9.0.5150";

  src = fetchurl {
    url = "https://download.owncloud.com/desktop/ownCloud/stable/${version}/source/ownCloud-${version}.tar.xz";
    sha256 = "0nf68x840p30yng4fh1nlyiqg40z0rkcv0lskpz8dd4pj1iw5jjs";
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
