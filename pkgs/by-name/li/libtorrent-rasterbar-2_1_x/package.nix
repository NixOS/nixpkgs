{
  lib,
  stdenv,
  boost,
  fetchFromGitHub,
  cmake,
  openssl,
  python3,
}:

let
  # Make sure we override python, so the correct version is chosen
  boostPython = boost.override {
    enablePython = true;
    python = python3;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libtorrent-rasterbar";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "arvidn";
    repo = "libtorrent";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-hQdwzGhDt9V0pJHRPSSCUshX80sWnIpPnuiO0zkb8Cg=";
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
  __structuredAttrs = true;

  patches = [
    ./python-destdir.patch
  ];

  postPatch = ''
    substituteInPlace cmake/Modules/GeneratePkgConfig/target-compile-settings.cmake.in \
      --replace-fail \
        'set(_INSTALL_LIBDIR "@CMAKE_INSTALL_LIBDIR@")' \
        'set(_INSTALL_LIBDIR "@CMAKE_INSTALL_LIBDIR@")
         set(_INSTALL_FULL_LIBDIR "@CMAKE_INSTALL_FULL_LIBDIR@")' \
      --replace-fail \
        'set(_INSTALL_INCLUDEDIR "@CMAKE_INSTALL_INCLUDEDIR@")' \
        'set(_INSTALL_INCLUDEDIR "@CMAKE_INSTALL_FULL_INCLUDEDIR@")'

    substituteInPlace cmake/Modules/GeneratePkgConfig/pkg-config.cmake.in \
      --replace-fail '$'{prefix}/@_INSTALL_LIBDIR@ @_INSTALL_FULL_LIBDIR@
  '';

  postInstall = ''
    moveToOutput "include" "$dev"
    moveToOutput "lib/${python3.libPrefix}" "$python"

    pc="$(find "$out" -type f -name 'libtorrent-rasterbar.pc' -print -quit)"

    substituteInPlace "$pc" \
      --replace-fail "$out/$dev" "$dev"

    mkdir -p "$dev/lib/pkgconfig"
    mv "$pc" "$dev/lib/pkgconfig/libtorrent-rasterbar.pc"
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
    (lib.cmakeBool "python-bindings" true)
  ];

  meta = {
    homepage = "https://libtorrent.org/";
    description = "Efficient feature complete C++ bittorrent implementation";
    changelog = "https://github.com/arvidn/libtorrent/blob/${finalAttrs.src.tag}/ChangeLog";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
