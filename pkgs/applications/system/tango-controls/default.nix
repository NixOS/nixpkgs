{ cmake
, cppzmq
, doxygen
, fetchurl
, graphviz
, lib
, libjpeg_turbo
, libsodium
, mariadb-connector-c
, openjdk11
, pkg-config
, python3
, stdenv
, systemd
, zeromq
, zlib
}:
let
  # omniorb is in nixpkgs, but tango doesn't support the latest version
  omniorb_4_2 = stdenv.mkDerivation rec {
    pname = "omniorb";
    version = "4.2.5";

    src = fetchurl {
      url = "mirror://sourceforge/project/omniorb/omniORB/omniORB-${version}/omniORB-${version}.tar.bz2";
      sha256 = "1fvkw3pn9i2312n4k3d4s7892m91jynl8g1v2z0j8k1gzfczjp7h";
    };

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ python3 ];

    enableParallelBuilding = true;
    hardeningDisable = [ "format" ];
  };
in
stdenv.mkDerivation rec {
  pname = "tango-controls";
  version = "9.4.2";

  src = fetchurl {
    url = "https://gitlab.com/api/v4/projects/24125890/packages/generic/TangoSourceDistribution/${version}/tango-${version}.tar.gz";
    hash = "sha256-3KQYBNd450gBRqJBa0SHXWXIADfpdNPeBLskXGTPqBY=";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    zlib
    omniorb_4_2
    zeromq
    cppzmq
    libjpeg_turbo
    mariadb-connector-c
    libsodium
    doxygen
    # needed for the docs
    graphviz
  ] ++ lib.optional (!stdenv.isDarwin) systemd;
  propagatedBuildInputs = [ omniorb_4_2 cppzmq zeromq libjpeg_turbo ];

  cmakeFlags = [
    "-DMySQL_LIBRARY_RELEASE=${mariadb-connector-c}/lib/mariadb/libmariadb${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DMySQL_INCLUDE_DIR=${mariadb-connector-c.dev}/include/mariadb"
    "-DMySQL_EXECUTABLE=${mariadb-connector-c}/bin/mariadb"
    "-DCMAKE_VERBOSE_MAKEFILE=TRUE"
    "-DCMAKE_SKIP_RPATH=ON"
    "-DTSD_TAC=ON"
    "-DTSD_JAVA_PATH=${openjdk11}"
  ];

  # To build proper systemd services for Tango, we need a way to tell when the DB service is started.
  # This patch adds systemd support for this.
  patches = lib.optional (!stdenv.isDarwin) ./sd_notify_cmake.patch;

  postPatch = ''
    sed -i -e 's#Requires: libzmq#Requires: libzmq cppzmq#' -e 's#libdir=.*#libdir=@CMAKE_INSTALL_FULL_LIBDIR@#' lib/cpp/tango.pc.cmake
    sed -i -e 's#libdir=.*#libdir=@CMAKE_INSTALL_FULL_LIBDIR@#' lib/idl/tangoidl.pc.cmake
  '';

  # Make sql migration scripts executable from anywhere (don't depend on relative paths)
  postInstall = ''
    mkdir -p $out/share/sql
    for fn in cppserver/database/*sql; do
      sed -e "s#^source #source $out/share/sql/#" "$fn" > $out/share/sql/$(basename "$fn")
    done
  '';

  meta = with lib; {
    description = "Open Source solution for SCADA and DCS";
    longDescription = ''
      Tango Controls is a toolkit for connecting hardware and software together. It is a mature software which is used by tens of sites to run highly complicated accelerator complexes and experiments 24 hours a day. It is free and Open Source. It is ideal for small and large installations. It provides full support for 3 programming languages - C++, Python and Java.
    '';
    homepage = "https://www.tango-controls.org";
    changelog = "https://gitlab.com/tango-controls/cppTango/-/blob/main/RELEASE_NOTES.md";
    downloadPage = "https://gitlab.com/tango-controls/TangoSourceDistribution/-/releases";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pmiddend ];
    platforms = platforms.unix;
  };

}
