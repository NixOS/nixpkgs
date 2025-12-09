{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libtool,
  libxml2,
  minizip,
  pcsclite,
  opensc,
  openssl,
  pkg-config,
  zlib,
  xmlsec,
  xxd,
}:

stdenv.mkDerivation rec {
  version = "4.3.0";
  pname = "libdigidocpp";

  src = fetchFromGitHub {
    owner = "open-eid";
    repo = "libdigidocpp";
    tag = "v${version}";
    hash = "sha256-f5wU3C6NC4op+9Wy+khwNJ6slFyPhq7hZl1Tj5hnYc8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    xxd
  ];

  buildInputs = [
    libxml2
    minizip
    pcsclite
    opensc
    openssl
    zlib
    xmlsec
  ];

  outputs = [
    "out"
    "lib"
    "dev"
    "bin"
  ];

  cmakeFlags = [
    (lib.cmakeFeature "PKCS11_MODULE" "${lib.getLib opensc}/lib/opensc-pkcs11.so")
  ];

  # This wants to link to ${CMAKE_DL_LIBS} (ltdl), and there doesn't seem to be
  # a way to tell CMake where this should be pulled from.
  # A cleaner fix would probably be to patch cmake to use
  # `-L${libtool.lib}/lib -ltdl` for `CMAKE_DL_LIBS`, but that's a world rebuild.
  env.NIX_LDFLAGS = "-L${libtool.lib}/lib";

  # Prevent cmake from creating a file that sets INTERFACE_INCLUDE_DIRECTORIES to the wrong location,
  # causing downstream build failures.
  postFixup = ''
    sed '/^  INTERFACE_INCLUDE_DIRECTORIES/s|"[^"]*/include"|"${placeholder "dev"}/include"|' \
      -i "$dev"/lib/cmake/libdigidocpp/libdigidocpp-config.cmake
  '';

  meta = with lib; {
    description = "Library for creating DigiDoc signature files";
    mainProgram = "digidoc-tool";
    homepage = "https://www.id.ee/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [
      maintainers.flokli
    ];
  };
}
