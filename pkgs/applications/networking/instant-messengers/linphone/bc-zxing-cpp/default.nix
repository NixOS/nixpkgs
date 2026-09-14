{
  lib,
  cmake,
  fetchFromGitLab,
  stdenv,
  libzint,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zxing-cpp";
  # Version taken from CMakeLists.txt - likely not actively updated
  version = "1.4.0-unstable-2026-08-08";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    group = "BC";
    owner = "public/external";
    repo = "zxing-cpp";
    rev = "722123ad0cadee0e4c313f80eac5162a9f8d7d73";
    sha256 = "sha256-GhrrIk2Kph6H5qs0g01b98F1Xzh/6vCS3+p+q0mhqcQ=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libzint
  ];

  cmakeFlags = [
    "-DZXING_BLACKBOX_TESTS=OFF"
    "-DZXING_DEPENDENCIES=LOCAL"
    "-DZXING_EXAMPLES=OFF"
    "-DZXING_USE_BUNDLED_ZINT=OFF"
  ];

  # The BC fork's zxing.pc.in joins @CMAKE_INSTALL_LIBDIR@/INCLUDEDIR@ onto a
  # hardcoded "/" prefix, and never includes GNUInstallDirs, causing us to run into
  # https://github.com/NixOS/nixpkgs/issues/144170
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail '# PC file generation.' 'include (GNUInstallDirs)'
    substituteInPlace zxing.pc.in \
      --replace-fail 'libdir=''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@' 'libdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
      --replace-fail 'includedir=''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@' 'includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@'
  '';

  meta = {
    homepage = "https://gitlab.linphone.org/BC/public/external/zxing-cpp";
    description = "BelledonneCommunications' fork of zxing-cpp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ naxdy ];
    platforms = lib.platforms.unix;
  };
})
