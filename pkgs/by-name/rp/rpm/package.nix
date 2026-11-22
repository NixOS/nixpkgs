{
  stdenv,
  lib,
  pkg-config,
  cmake,
  fetchFromGitHub,
  zlib,
  bzip2,
  file,
  elfutils,
  libarchive,
  libcap_ng,
  readline,
  audit,
  popt,
  xz,
  python3,
  lua5_5,
  llvmPackages,
  sqlite,
  zstd,
  libcap,
  #, libselinux
  rpm-sequoia,
  gettext,
  systemd,
  gnupg,
  scdoc,

  # Disable the unshare RPM plugin, which can be useful if
  # RPM is ran within the Nix sandbox.
  disableUnshare ? true,
}:

let
  lua = lua5_5;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rpm";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "rpm";
    tag = "rpm-${finalAttrs.version}-release";
    hash = "sha256-+ugPW3dJ2qULYTIkgS1g6MU5otnF26SJe8ltsFrpUiE=";
  };

  postPatch = ''
    sed -i 's#''${Python3_SITEARCH}#${placeholder "out"}/${python3.sitePackages}#' python/CMakeLists.txt
    sed -i 's#PATHS ENV MYPATH#PATHS ENV PATH#' CMakeLists.txt
    # Compat symlinks assume CMAKE_INSTALL_BINDIR is relative
    substituteInPlace CMakeLists.txt \
      --replace-fail "../../\''${CMAKE_INSTALL_BINDIR}" "\''${CMAKE_INSTALL_FULL_BINDIR}"
  '';

  outputs = [
    "out"
    "man"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "dev"
  ];
  separateDebugInfo = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    gettext
    scdoc
  ];
  buildInputs = [
    bzip2
    zlib
    zstd
    file
    libarchive
    xz
    lua
    sqlite
    readline
    rpm-sequoia
    gnupg
  ]
  ++ lib.optional stdenv.cc.isClang llvmPackages.openmp
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap
    audit
    systemd
    libcap_ng
  ];

  cmakeFlags = [
    "-DWITH_DBUS=OFF"
    # libselinux is missing propagatedBuildInputs
    "-DWITH_SELINUX=OFF"

    "-DCMAKE_INSTALL_LOCALSTATEDIR=/var"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isLinux) [
    "-DWITH_CAP=OFF"
    "-DWITH_AUDIT=OFF"
    "-DWITH_ACL=OFF"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DWITH_LIBELF=OFF"
    "-DWITH_LIBDW=OFF"
  ]
  ++ lib.optionals disableUnshare [
    "-DHAVE_UNSHARE=OFF"
  ];

  # rpm/rpmlib.h includes popt.h, and then the pkg-config file mentions these as linkage requirements
  propagatedBuildInputs = [
    popt
  ]
  ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform elfutils) elfutils;

  enableParallelBuilding = true;
  __structuredAttrs = true;

  meta = {
    homepage = "https://www.rpm.org/";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    description = "RPM package manager";
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
