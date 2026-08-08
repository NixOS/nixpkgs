{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
  pkg-config,
  openssl,
  p11-kit,
}:

stdenv.mkDerivation rec {
  pname = "libp11";
  version = "0.4.18";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "libp11";
    rev = "${pname}-${version}";
    sha256 = "sha256-bvVUiv8y5c0P9fHAFs1JX3V7xsorbKUmm0qt3l2SoQQ=";
  };

  configureFlags = [
    "--with-enginesdir=${placeholder "out"}/lib/engines"
    "--with-modulesdir=${placeholder "out"}/lib/ossl-module"
    # Without a default module, the pkcs11 engine/provider is useless unless the
    # application explicitly configures a PKCS#11 module path, which most don't
    # (e.g. wpa_supplicant with EAP-TLS client certificates on a smartcard/TPM).
    # Upstream defaults to the p11-kit proxy, which in turn loads the modules
    # configured system-wide; it is only skipped when p11-kit is not found.
    "--with-pkcs11-module=${lib.getLib p11-kit}/lib/p11-kit-proxy.so"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    libtool
  ];

  buildInputs = [ openssl ];

  enableParallelBuilding = true;

  passthru = { inherit openssl; };

  meta = {
    description = "Small layer on top of PKCS#11 API to make PKCS#11 implementations easier";
    homepage = "https://github.com/OpenSC/libp11";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
  };
}
