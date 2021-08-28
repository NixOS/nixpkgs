{ lib, fetchurl, mkDerivation, cmake, pkg-config, qtbase, qtkeychain, sqlite, libsecret }:

mkDerivation rec {
  pname = "owncloud-client";
  version = "2.6.3.14058";

  src = fetchurl {
    url = "https://download.owncloud.com/desktop/stable/owncloudclient-${version}.tar.xz";
    sha256 = "1xcklhvbyg34clm9as2rjnjfwxpwq77lmdxj6qc0w7q43viqvlz3";
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ qtbase qtkeychain sqlite ];

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
