{
  stdenv,
  fetchurl,
  lib,
  cmake,
  cacert,
  fetchpatch,
  buildShared ? !stdenv.hostPlatform.isStatic,
}:

let
  ldLibPathEnvName = if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";

  generic =
    {
      version,
      hash,
      patches ? [ ],
      postPatch ? "",
      knownVulnerabilities ? [ ],
    }:
    stdenv.mkDerivation {
      pname = "libressl";
      inherit version;

      src = fetchurl {
        url = "mirror://openbsd/LibreSSL/libressl-${version}.tar.gz";
        inherit hash;
      };

      nativeBuildInputs = [ cmake ];

      cmakeFlags = [
        "-DENABLE_NC=ON"
        # Ensure that the output libraries do not require an executable stack.
        # Without this define, assembly files in libcrypto do not include a
        # .note.GNU-stack section, and if that section is missing from any object,
        # the linker will make the stack executable.
        "-DCMAKE_C_FLAGS=-DHAVE_GNU_STACK"
        "-DTLS_DEFAULT_CA_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt"
      ]
      ++ lib.optional buildShared "-DBUILD_SHARED_LIBS=ON";

      # The autoconf build is broken as of 2.9.1, resulting in the following error:
      # libressl-2.9.1/tls/.libs/libtls.a', needed by 'handshake_table'.
      # Fortunately LibreSSL provides a CMake build as well, so opt for CMake by
      # removing ./configure pre-config.
      preConfigure = ''
        rm configure
      '';

      inherit patches;

      postPatch = ''
        patchShebangs tests/
      ''
      + postPatch;

      doCheck = !(stdenv.hostPlatform.isPower64 || stdenv.hostPlatform.isRiscV);
      preCheck = ''
        export PREVIOUS_${ldLibPathEnvName}=$${ldLibPathEnvName}
        export ${ldLibPathEnvName}="$${ldLibPathEnvName}:$(realpath tls/):$(realpath ssl/):$(realpath crypto/)"
      '';
      postCheck = ''
        export ${ldLibPathEnvName}=$PREVIOUS_${ldLibPathEnvName}
      '';

      outputs = [
        "bin"
        "dev"
        "out"
        "man"
        "nc"
      ];

      postFixup = ''
        moveToOutput "bin/nc" "$nc"
        moveToOutput "bin/openssl" "$bin"
        moveToOutput "bin/ocspcheck" "$bin"
        moveToOutput "share/man/man1/nc.1.gz" "$nc"
      '';

      meta = {
        description = "Free TLS/SSL implementation";
        homepage = "https://www.libressl.org";
        license = with lib.licenses; [
          publicDomain
          bsdOriginal
          bsd0
          bsd3
          gpl3
          isc
          openssl
        ];
        platforms = lib.platforms.all;
        maintainers = with lib.maintainers; [
          thoughtpolice
          fpletz
        ];
        inherit knownVulnerabilities;

        # OpenBSD believes that PowerPC should be always-big-endian;
        # this assumption seems to have propagated into recent
        # releases of libressl.  Since libressl is aliased to many
        # other packages (e.g. netcat) it's important to fail early
        # here, otherwise it's very difficult to figure out why
        # libressl is getting dragged into a failing build.
        badPlatforms = with lib.systems.inspect.patterns; [
          (lib.recursiveUpdate isPower64 isLittleEndian)
        ];
      };
    };
  # https://github.com/libressl/portable/pull/1206
  common-cmake-install-full-dirs-patch = fetchpatch {
    url = "https://github.com/libressl/portable/commit/a15ea0710398eaeed3be53cf643e80a1e80c981d.patch";
    hash = "sha256-Mlf4SrGCCqALQicbGtmVGdkdfcE8DEGYkOuVyG2CozM=";
  };
in
{
  libressl_4_1 = generic {
    version = "4.1.2";
    hash = "sha256-+6Ti+ip/UjBt96OJlwoQ6YuX6w7bKZqf252/SZmcYeE=";
    # Fixes build on loongarch64
    # https://github.com/libressl/portable/pull/1184
    postPatch = ''
      mkdir -p include/arch/loongarch64
      cp ${
        fetchurl {
          url = "https://github.com/libressl/portable/raw/refs/tags/v4.1.0/include/arch/loongarch64/opensslconf.h";
          hash = "sha256-68dw5syUy1z6GadCMR4TR9+0UQX6Lw/CbPWvjHGAhgo=";
        }
      } include/arch/loongarch64/opensslconf.h
    '';
    patches = [
      common-cmake-install-full-dirs-patch
    ];
  };

  libressl_4_2 = generic {
    version = "4.2.1";
    hash = "sha256-bVwvWFg1iOp5H0yGRQBAcdAN+lVKW/eIoAbKHrWr1ws=";
    patches = [
      common-cmake-install-full-dirs-patch
    ];
  };
}
