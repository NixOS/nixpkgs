{ stdenv, fetchgit, cmake, pkgconfig, qtbase, qtwebkit, qtkeychain, sqlite }:

stdenv.mkDerivation rec {
  name = "nextcloud-client-${version}";
  version = "2.3.2";

  src = fetchgit {
    url = "git://github.com/nextcloud/client_theming.git";
    rev = "1ee750d1aeaaefc899629e85c311594603e9ac1b";
    sha256 = "0dxyng8a7cg78z8yngiqypsb44lf5c6vkabvkfch0cl0cqmarc1a";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ qtbase qtwebkit qtkeychain sqlite ];

  preConfigure = ''
    cmakeFlagsArray+=("-UCMAKE_INSTALL_LIBDIR" "-DOEM_THEME_DIR=$(realpath ./nextcloudtheme)" "../client")
  '';

  meta = with stdenv.lib; {
    description = "Nextcloud themed desktop client";
    homepage = https://nextcloud.com;
    license = licenses.gpl2;
    maintainers = with maintainers; [ caugner ];
    platforms = platforms.unix;
  };
}
