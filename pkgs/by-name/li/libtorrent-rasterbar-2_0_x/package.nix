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
  version = "2.0.11";

  src = fetchFromGitHub {
    owner = "arvidn";
    repo = "libtorrent";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-iph42iFEwP+lCWNPiOJJOejISFF6iwkGLY9Qg8J4tyo=";
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
      --replace-fail \
        'set(_INSTALL_LIBDIR "@CMAKE_INSTALL_LIBDIR@")' \
        'set(_INSTALL_LIBDIR "@CMAKE_INSTALL_LIBDIR@")
         set(_INSTALL_FULL_LIBDIR "@CMAKE_INSTALL_FULL_LIBDIR@")'
  ''
  # a: libdir=''${prefix}//nix/store/...
  # b: libdir=/nix/store/...
  # https://github.com/NixOS/nixpkgs/issues/144170
  + ''
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
  ''
  # a: Cflags: ... -I/nix/store/x//nix/store/x-dev/include ...
  # b: Cflags: ... -I/nix/store/x-dev/include ...
  + ''
    substituteInPlace $dev/lib/pkgconfig/libtorrent-rasterbar.pc \
      --replace-fail "$out/$dev" "$dev"
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
