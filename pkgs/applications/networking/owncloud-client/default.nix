{ lib, fetchurl, fetchFromGitHub, mkDerivation, cmake, extra-cmake-modules, pkg-config, qttools, qtbase, qtkeychain, qtdeclarative, inotify-tools, sqlite, libsecret }:

let
  libre-graph-api = mkDerivation rec {
    pname = "libre-graph-api-cpp-qt-client";
    version = "1.0.1";

    src = fetchFromGitHub {
      owner = "owncloud";
      repo = pname;
      rev = "31ca753c65864a494f92654f7443f57d39a72072";
      sha256 = "sha256-oHWhiSGcgvfImND4PdkWCdS2AGjwwim5oGSpwO8BstM=";
    };

    sourceRoot = "source/client";

    nativeBuildInputs = [ pkg-config cmake extra-cmake-modules ];
    buildInputs = [ qtbase ];
  };
in
mkDerivation rec {
  pname = "owncloud-client";
  version = "3.2.0.10193";

  src = fetchurl {
    url = "https://download.owncloud.com/desktop/ownCloud/stable/${version}/source/ownCloud-${version}.tar.xz";
    sha256 = "sha256-QcNKpvXOgzHRUSVJaQt8ncKkViBan65RhDCJJOspH3Y=";
  };

  nativeBuildInputs = [ pkg-config cmake extra-cmake-modules qttools ];
  buildInputs = [ qtbase qtdeclarative qtkeychain inotify-tools sqlite libsecret libre-graph-api ];

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
