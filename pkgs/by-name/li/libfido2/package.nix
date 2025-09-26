{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  hidapi,
  libcbor,
  openssl,
  udev,
  udevCheckHook,
  zlib,
  withPcsclite ? true,
  pcsclite,
}:

stdenv.mkDerivation rec {
  pname = "libfido2";
  version = "1.16.0";

  # releases on https://developers.yubico.com/libfido2/Releases/ are signed
  src = fetchurl {
    url = "https://developers.yubico.com/${pname}/Releases/${pname}-${version}.tar.gz";
    hash = "sha256-jCtvsnm1tC6aySrecYMuSFhSZHtTYHxDuqr7vOzqBOQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    udevCheckHook
  ];

  buildInputs = [
    libcbor
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ hidapi ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ udev ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && withPcsclite) [ pcsclite ];

  propagatedBuildInputs = [ openssl ];

  outputs = [
    "out"
    "dev"
    "man"
  ];

  doInstallCheck = true;

  cmakeFlags = [
    "-DUDEV_RULES_DIR=${placeholder "out"}/etc/udev/rules.d"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DUSE_HIDAPI=1"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "-DNFC_LINUX=1"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && withPcsclite) [
    "-DUSE_PCSC=1"
  ];

  # causes possible redefinition of _FORTIFY_SOURCE?
  hardeningDisable = [ "fortify3" ];

  meta = with lib; {
    description = ''
      Provides library functionality for FIDO 2.0, including communication with a device over USB.
    '';
    homepage = "https://github.com/Yubico/libfido2";
    license = licenses.bsd2;
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.unix;
  };
}
