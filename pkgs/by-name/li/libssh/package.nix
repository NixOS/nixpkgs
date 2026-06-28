{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  cmake,
  zlib,
  openssl,
  libsodium,

  withGssapi ? false,
  krb5,

  # for passthru.tests
  ffmpeg,
  sshping,
  wireshark,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libssh";
  version = "0.12.0";

  src = fetchurl {
    url = "https://www.libssh.org/files/${lib.versions.majorMinor finalAttrs.version}/libssh-${finalAttrs.version}.tar.xz";
    hash = "sha256-Gmr0JNgyfl7t705f5/W5JCJt1hesnz3oDyF9gqNqcSE=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  __structuredAttrs = true;

  postPatch = ''
    # Fix headers to use libsodium instead of NaCl
    sed -i 's,nacl/,sodium/,g' ./include/libssh/curve25519.h src/curve25519.c
  '';

  cmakeFlags = [
    # Don’t build examples, which are not installed and require additional dependencies not
    # included in `buildInputs` such as libx11.
    "-DWITH_EXAMPLES=OFF"

    (lib.cmakeBool "USE_GSSAPI" withGssapi)
  ];

  buildInputs = [
    zlib
    openssl
    libsodium
  ]
  ++ lib.optional withGssapi krb5;

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

  meta = {
    description = "SSH client library";
    homepage = "https://libssh.org";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.all;
  };
})
