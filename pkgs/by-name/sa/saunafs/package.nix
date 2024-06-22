{
  lib,
  gcc11Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  acl,
  boost175,
  bzip2,
  db,
  fmt_10,
  fuse3,
  judy,
  linux-pam,
  spdlog,
  xz,
  yaml-cpp,
  zlib,
  zstd,
}:

gcc11Stdenv.mkDerivation rec {
  pname = "saunafs";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "leil-io";
    repo = "saunafs";
    rev = "v${version}";
    hash = "sha256-rEiiBHB1wRqpnSgFgqVGwA3kOwiDx6MgyTmWyIQHATU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    (boost175.override { stdenv = gcc11Stdenv; })
    (yaml-cpp.override { stdenv = gcc11Stdenv; })
    acl
    bzip2
    db
    fmt_10
    fuse3
    judy
    linux-pam
    spdlog
    xz
    zlib
    zstd
  ];

  cmakeFlags = [
    "-DENABLE_CLIENT_LIB=ON"
    "-DENABLE_NFS_GANESHA=OFF"
    "-DENABLE_WERROR=ON"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DENABLE_CCACHE=OFF"
  ];

  meta = with lib; {
    description = "A distributed POSIX file system inspired by Google File System";
    homepage = "https://saunafs.com";
    changelog = "https://github.com/leil-io/saunafs/blob/${src.rev}/NEWS";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      _0x4A6F
      cheriimoya
    ];
    mainProgram = "saunafs";
    platforms = platforms.linux;
  };
}
