{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  boost,
  openssl,
  python3,
  ncurses,
}:

let
  version = "2.0.11";

  # Make sure we override python, so the correct version is chosen
  boostPython = boost.override {
    enablePython = true;
    python = python3;
  };

in
stdenv.mkDerivation {
  pname = "libtorrent-rasterbar";
  inherit version;

  src = fetchFromGitHub {
    owner = "arvidn";
    repo = "libtorrent";
    tag = "v${version}";
    hash = "sha256-iph42iFEwP+lCWNPiOJJOejISFF6iwkGLY9Qg8J4tyo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    boostPython
    openssl
  ];

  strictDeps = true;

  patches = [
    # provide distutils alternative for python 3.12
    ./distutils.patch
  ];

  # https://github.com/arvidn/libtorrent/issues/6865
  postPatch = ''
    substituteInPlace cmake/Modules/GeneratePkgConfig/target-compile-settings.cmake.in \
      --replace-fail 'set(_INSTALL_LIBDIR "@CMAKE_INSTALL_LIBDIR@")' \
                     'set(_INSTALL_LIBDIR "@CMAKE_INSTALL_LIBDIR@")
                      set(_INSTALL_FULL_LIBDIR "@CMAKE_INSTALL_FULL_LIBDIR@")'
    substituteInPlace cmake/Modules/GeneratePkgConfig/pkg-config.cmake.in \
      --replace-fail '$'{prefix}/@_INSTALL_LIBDIR@ @_INSTALL_FULL_LIBDIR@
  '';

  postInstall = ''
    moveToOutput "include" "$dev"
    moveToOutput "lib/${python3.libPrefix}" "$python"
  '';

  postFixup = ''
    substituteInPlace "$dev/lib/cmake/LibtorrentRasterbar/LibtorrentRasterbarTargets-release.cmake" \
      --replace-fail "\''${_IMPORT_PREFIX}/lib" "$out/lib"
  '';

  outputs = [
    "out"
    "dev"
    "python"
  ];

  cmakeFlags = [
    "-Dpython-bindings=on"
  ];

  meta = with lib; {
    homepage = "https://libtorrent.org/";
    description = "C++ BitTorrent implementation focusing on efficiency and scalability";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
