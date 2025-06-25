{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  cmake,
  zlib,
  openssl,
  libsodium,

  # for passthru.tests
  ffmpeg,
  sshping,
  wireshark,
}:

stdenv.mkDerivation rec {
  pname = "libssh";
  version = "0.11.2";

  src = fetchurl {
    url = "https://www.libssh.org/files/${lib.versions.majorMinor version}/libssh-${version}.tar.xz";
    hash = "sha256-aVKfwY9bYB8Lrw5aRQGivCbfXi8Rb1+PB/Gfr6ptBOc=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    # Fix headers to use libsodium instead of NaCl
    sed -i 's,nacl/,sodium/,g' ./include/libssh/curve25519.h src/curve25519.c
  '';

  # Don’t build examples, which are not installed and require additional dependencies not
  # included in `buildInputs` such as libX11.
  cmakeFlags = [ "-DWITH_EXAMPLES=OFF" ];

  buildInputs = [
    zlib
    openssl
    libsodium
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  postFixup = ''
    substituteInPlace $dev/lib/cmake/libssh/libssh-config.cmake \
      --replace-fail "set(_IMPORT_PREFIX \"$out\")" "set(_IMPORT_PREFIX \"$dev\")"
  '';

  passthru.tests = {
    inherit ffmpeg sshping wireshark;
  };

  meta = with lib; {
    description = "SSH client library";
    homepage = "https://libssh.org";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ sander ];
    platforms = platforms.all;
  };
}
