{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
  pkg-config,
  openssl,
  p11-kit,
  runCommand,
  libp11,
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

  passthru = {
    inherit openssl;

    tests.default-pkcs11-module =
      runCommand "libp11-default-pkcs11-module" { nativeBuildInputs = [ (lib.getBin openssl) ]; }
        ''
          # The default module path is baked into both the engine and the provider.
          grep -q "${lib.getLib p11-kit}/lib/p11-kit-proxy.so" ${libp11}/lib/engines/pkcs11.so
          grep -q "${lib.getLib p11-kit}/lib/p11-kit-proxy.so" ${libp11}/lib/ossl-module/pkcs11prov.so

          export OPENSSL_ENGINES=${libp11}/lib/engines
          openssl engine -t pkcs11 | grep -F "[ available ]"

          # Loading a key forces the engine to load its PKCS#11 module.
          # No token is present in the sandbox, so the command fails either way;
          # assert that the failure is a key lookup failure (the p11-kit proxy
          # loaded, with zero modules configured) and not a module load failure.
          openssl pkeyutl -engine pkcs11 -keyform engine \
            -inkey "pkcs11:object=missing" -sign 2>stderr.log || true
          cat stderr.log
          grep -qF "Could not find private key" stderr.log
          if grep -qF "Unable to load PKCS#11 module" stderr.log; then
            echo "the pkcs11 engine failed to load its default PKCS#11 module" >&2
            exit 1
          fi

          touch $out
        '';
  };

  meta = {
    description = "Small layer on top of PKCS#11 API to make PKCS#11 implementations easier";
    homepage = "https://github.com/OpenSC/libp11";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
  };
}
