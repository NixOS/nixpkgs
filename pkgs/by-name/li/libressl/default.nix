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

      strictDeps = true;
      __structuredAttrs = true;

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
        # Bail if any shared object has executable stack enabled. This can
        # happen when an object produced from an assmbly file in libcrypto is
        # missing a .note.GNU-stack section. An executable stack is dangerous
        # and unintentional, but without this check the derivation will build
        # and even run if W^X is not enforced; it would fail dangerously.
        objdump -p **/*.so | awk '
          BEGIN { res = 0 }
          /file format/ { file = $1 }
          /STACK/ { stack = 1; next }
          stack {
            if ($0 ~ /flags.*x/) { print file " has executable stack"; res = 1 }
            stack = 0
          }
          END { exit res }
        '

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
          ruuda
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
        identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "openbsd" version;
      };
    };

  # https://github.com/libressl/portable/pull/1206
  # This got merged in February 2026 and is included as of LibreSSL 4.3.0.
  common-cmake-install-full-dirs-patch = fetchpatch {
    url = "https://github.com/libressl/portable/commit/a15ea0710398eaeed3be53cf643e80a1e80c981d.patch";
    hash = "sha256-Mlf4SrGCCqALQicbGtmVGdkdfcE8DEGYkOuVyG2CozM=";
  };
in
{
  # 4.2 was released October 2025 and will become unsupported on October 22,
  # 2026, one year after the release of OpenBSD 7.8.
  libressl_4_2 = generic {
    version = "4.2.1";
    hash = "sha256-bVwvWFg1iOp5H0yGRQBAcdAN+lVKW/eIoAbKHrWr1ws=";
    patches = [
      common-cmake-install-full-dirs-patch
    ];
  };

  # 4.3 was released April 2026 and will become unsupported one year after the
  # release of OpenBSD 7.9.
  libressl_4_3 = generic {
    version = "4.3.1";
    hash = "sha256-wttCrOFOfVQZgm+rNadC7G5NEnJaBRpR0M6jwQug+lA=";
    patches = [
      # Fix for https://github.com/libressl/portable/issues/1278, where LibreSSL
      # 4.3 started requiring executable stack because some objects were missing
      # a .note.GNU-stack section; will probably be included in the next release.
      (fetchpatch {
        url = "https://raw.githubusercontent.com/libressl/portable/4dae91d056c6c75ba5cf2bc5e6148b8e02239119/patches/gnu-stack.patch";
        hash = "sha256-Q1oWL4N8w5Zmjfq5QkTJR53NgZ4GqChSDaBicli5G2I=";
        # This patch is written to be applied with -p0, with no leading path
        # component, but Nix applies with -p1 by default, so we add it to not
        # break compatibility with how other patches must be applied.
        decode = "sed 's|^--- |--- a/|; s|^+++ |+++ b/|'";
      })
    ];
  };
}
