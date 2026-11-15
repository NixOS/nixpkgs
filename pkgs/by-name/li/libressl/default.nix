{
  stdenv,
  fetchurl,
  lib,
  cmake,
  fetchpatch,
  buildShared ? !stdenv.hostPlatform.isStatic,
}:

let
  ldLibPathEnvName = if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";

  # Same paths as openssl's use-etc-ssl-certs patches.
  hostCaFile =
    if stdenv.hostPlatform.isDarwin then
      "/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt"
    else
      "/etc/ssl/certs/ca-certificates.crt";

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
        "-DTLS_DEFAULT_CA_FILE=${hostCaFile}"
        # The default is the relative path "etc/ssl", resolved against the current directory.
        "-DOPENSSLDIR=${placeholder "out"}/etc/ssl"
      ]
      ++ lib.optional buildShared "-DBUILD_SHARED_LIBS=ON";

      # The autoconf build is broken as of 2.9.1, resulting in the following error:
      # libressl-2.9.1/tls/.libs/libtls.a', needed by 'handshake_table'.
      # Fortunately LibreSSL provides a CMake build as well, so opt for CMake by
      # removing ./configure pre-config.
      preConfigure = ''
        rm configure
      '';

      patches = [ ./nix-ssl-cert-file.patch ] ++ patches;

      postPatch = ''
        patchShebangs tests/
        substituteInPlace crypto/crypto_local.h \
          --replace-fail 'OPENSSLDIR "/cert.pem"' '"${hostCaFile}"'
      ''
      + postPatch;

      doCheck = !(stdenv.hostPlatform.isPower64 || stdenv.hostPlatform.isRiscV);
      preCheck = ''
        export PREVIOUS_${ldLibPathEnvName}=$${ldLibPathEnvName}
        export ${ldLibPathEnvName}="$${ldLibPathEnvName}:$(realpath tls/):$(realpath ssl/):$(realpath crypto/)"
      ''
      + lib.optionalString (stdenv.hostPlatform.isElf && buildShared) ''
        # Bail if any shared object has executable stack enabled. This can
        # happen when an object produced from an assmbly file in libcrypto is
        # missing a .note.GNU-stack section. An executable stack is dangerous
        # and unintentional, but without this check the derivation will build
        # and even run if W^X is not enforced; it would fail dangerously.
        $OBJDUMP -p **/*.so | awk '
          BEGIN { res = 0 }
          /file format/ { file = $1 }
          /STACK/ { stack = 1; next }
          stack {
            if ($0 ~ /flags.*x/) { print file " has executable stack"; res = 1 }
            stack = 0
          }
          END { exit res }
        '
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

      # Unused vendored CA bundle.
      postInstall = ''
        rm $out/etc/ssl/cert.pem
      '';

      postFixup = ''
        moveToOutput "bin/nc" "$nc"
        moveToOutput "bin/openssl" "$bin"
        moveToOutput "bin/ocspcheck" "$bin"
        moveToOutput "share/man/man1/nc.1.gz" "$nc"
      '';

      doInstallCheck = true;
      installCheckPhase = ''
        runHook preInstallCheck

        # A simple binary match for the path is enough.
        grep "${hostCaFile}" $out/lib/*libtls*
        grep "${hostCaFile}" $out/lib/*libcrypto*

        runHook postInstallCheck
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
in
{
  # 4.3 was released April 2026 and will become unsupported on May 19, 2027,
  # one year after the release of OpenBSD 7.9.
  libressl_4_3 = generic {
    version = "4.3.4";
    hash = "sha256-V8iy+Mb5UFWHq67dqwA+okPWFe237XGVeWgSH8Yxa9Y=";
    patches = [ ];
  };

  # 4.4 was released October 2026 and will become unsupported on October 20,
  # 2027, one year after the release of OpenBSD 8.0.
  libressl_4_4 = generic {
    version = "4.4.0";
    hash = "sha256-fQJSKtUHC5rbMuslPsq84YEYSjdQz2WrrAZ17pCGh8E=";
    patches = [ ];
  };
}
