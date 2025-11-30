{
  lib,
  stdenv,
  writeText,
  fetchFromGitHub,
  buildcatrust,
  blacklist ? [ ],
  extraCertificateFiles ? [ ],
  extraCertificateStrings ? [ ],

  # Used by update.sh
  nssOverride ? null,

  # Used for tests only
  runCommand,
  cacert,
  openssl,
}:

let
  blocklist = writeText "cacert-blocklist.txt" (lib.concatStringsSep "\n" blacklist);
  extraCertificatesBundle = writeText "cacert-extra-certificates-bundle.crt" (
    lib.concatStringsSep "\n\n" extraCertificateStrings
  );

  srcVersion = "3.115";
  version = if nssOverride != null then nssOverride.version else srcVersion;
  meta = with lib; {
    homepage = "https://curl.haxx.se/docs/caextract.html";
    description = "Bundle of X.509 certificates of public Certificate Authorities (CA)";
    platforms = platforms.all;
    maintainers = with maintainers; [
      fpletz
      lukegb
    ];
    license = licenses.mpl20;
  };
  certdata = stdenv.mkDerivation {
    pname = "nss-cacert-certdata";
    inherit version;

    src =
      if nssOverride != null then
        nssOverride.src
      else
        fetchFromGitHub {
          owner = "nss-dev";
          repo = "nss";
          rev = "NSS_${lib.replaceStrings [ "." ] [ "_" ] version}_RTM";
          hash = "sha256-8PeFeaIOtjBZJLBx3ONwZlK5SaLnjKEFoZWvVsu/3tA=";
        };

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp lib/ckfw/builtins/certdata.txt $out

      runHook postInstall
    '';

    inherit meta;
  };
in
stdenv.mkDerivation {
  pname = "nss-cacert";
  inherit version;

  src = certdata;

  outputs = [
    "out"
    "unbundled"
    "p11kit"
    "hashed"
  ];

  nativeBuildInputs = [ buildcatrust ];

  buildPhase = ''
    mkdir unbundled hashed
    buildcatrust \
      --certdata_input certdata.txt \
      --ca_bundle_input "${extraCertificatesBundle}" ${
        lib.escapeShellArgs (map (arg: "${arg}") extraCertificateFiles)
      } \
      --blocklist "${blocklist}" \
      --ca_bundle_output ca-bundle.crt \
      --ca_standard_bundle_output ca-no-trust-rules-bundle.crt \
      --ca_unpacked_output unbundled \
      --ca_hashed_unpacked_output hashed \
      --p11kit_output ca-bundle.trust.p11-kit
  '';

  installPhase = ''
    install -D -t "$out/etc/ssl/certs" ca-bundle.crt

    # install standard PEM compatible bundle
    install -D -t "$out/etc/ssl/certs" ca-no-trust-rules-bundle.crt

    # install p11-kit specific output to p11kit output
    install -D -t "$p11kit/etc/ssl/trust-source" ca-bundle.trust.p11-kit

    # install individual certs in unbundled output
    install -D -t "$unbundled/etc/ssl/certs" unbundled/*.crt

    # install hashed certs in hashed output
    # use cp as install doesn't copy symlinks
    mkdir -p $hashed/etc/ssl/certs/
    cp -P hashed/* $hashed/etc/ssl/certs/
  '';

  setupHook = ./setup-hook.sh;

  passthru = {
    updateScript = ./update.sh;
    tests =
      let
        isTrusted = ''
          isTrusted() {
            # isTrusted <unbundled-dir> <ca name> <ca sha256 fingerprint>
            for f in $1/etc/ssl/certs/*.crt; do
              if ! [[ -s "$f" ]]; then continue; fi
              fingerprint="$(openssl x509 -in "$f" -noout -fingerprint -sha256 | cut -f2 -d=)"
              if [[ "x$fingerprint" == "x$3" ]]; then
                # If the certificate is treated as rejected for TLS Web Server, then we consider it untrusted.
                if openssl x509 -in "$f" -noout -text | grep -q '^Rejected Uses:'; then
                  if openssl x509 -in "$f" -noout -text | grep -A1 '^Rejected Uses:' | grep -q 'TLS Web Server'; then
                    return 1
                  fi
                fi
                return 0
              fi
            done
            return 1
          }
        '';
      in
      {
        # Test that building this derivation with a blacklist works, and that UTF-8 is supported.
        blacklist-utf8 =
          let
            blacklistCAToFingerprint = {
              # "blacklist" uses the CA name from the NSS bundle, but we check for presence using the SHA256 fingerprint.
              "CFCA EV ROOT" =
                "5C:C3:D7:8E:4E:1D:5E:45:54:7A:04:E6:87:3E:64:F9:0C:F9:53:6D:1C:CC:2E:F8:00:F3:55:C4:C5:FD:70:FD";
              "NetLock Arany (Class Gold) Főtanúsítvány" =
                "6C:61:DA:C3:A2:DE:F0:31:50:6B:E0:36:D2:A6:FE:40:19:94:FB:D1:3D:F9:C8:D4:66:59:92:74:C4:46:EC:98";
            };
            mapBlacklist = f: lib.concatStringsSep "\n" (lib.mapAttrsToList f blacklistCAToFingerprint);
          in
          runCommand "verify-the-cacert-filter-output"
            {
              cacert = cacert.unbundled;
              cacertWithExcludes =
                (cacert.override {
                  blacklist = builtins.attrNames blacklistCAToFingerprint;
                }).unbundled;

              nativeBuildInputs = [ openssl ];
            }
            ''
              ${isTrusted}

              # Ensure that each certificate is in the main "cacert".
              ${mapBlacklist (
                caName: caFingerprint: ''
                  isTrusted "$cacert" "${caName}" "${caFingerprint}" || ({
                    echo "CA fingerprint ${caFingerprint} (${caName}) is missing from the CA bundle. Consider picking a different CA for the blacklist test." >&2
                    exit 1
                  })
                ''
              )}

              # Ensure that each certificate is NOT in the "cacertWithExcludes".
              ${mapBlacklist (
                caName: caFingerprint: ''
                  isTrusted "$cacertWithExcludes" "${caName}" "${caFingerprint}" && ({
                    echo "CA fingerprint ${caFingerprint} (${caName}) is present in the cacertWithExcludes bundle." >&2
                    exit 1
                  })
                ''
              )}

              touch "$out"
            '';

        # Test that we can add additional certificates to the store, and have them be trusted.
        extra-certificates =
          let
            extraCertificateStr = ''
              -----BEGIN CERTIFICATE-----
              MIIB5DCCAWqgAwIBAgIUItvsAYEIdYDkOIo5sdDYMcUaNuIwCgYIKoZIzj0EAwIw
              KTEnMCUGA1UEAwweTml4T1MgY2FjZXJ0IGV4dHJhIGNlcnRpZmljYXRlMB4XDTIx
              MDYxMjE5MDQzMFoXDTIyMDYxMjE5MDQzMFowKTEnMCUGA1UEAwweTml4T1MgY2Fj
              ZXJ0IGV4dHJhIGNlcnRpZmljYXRlMHYwEAYHKoZIzj0CAQYFK4EEACIDYgAEuP8y
              lAm6ZyQt9v/P6gTlV/a9R+D61WjucW04kaegOhg8csiluimYodiSv0Pbgymu+Zxm
              A3Bz9QGmytaYTiJ16083rJkwwIhqoYl7kWsLzreSTaLz87KH+rdeol59+H0Oo1Mw
              UTAdBgNVHQ4EFgQUCxuHfvqI4YVU5M+A0+aKvd1LrdswHwYDVR0jBBgwFoAUCxuH
              fvqI4YVU5M+A0+aKvd1LrdswDwYDVR0TAQH/BAUwAwEB/zAKBggqhkjOPQQDAgNo
              ADBlAjEArgxgjdNmRlSEuai0dzlktmBEDZKy2Iiul+ttSoce9ohfEVYESwO602HW
              keVvI56vAjBCro3dc3m2TuktiKO6lQV56PUEyxko4H/sR5pnHlduCGRDlFzQKXf/
              pMMmtj7cVb8=
              -----END CERTIFICATE-----
            '';
            extraCertificateFile = ./test-cert-file.crt;
            extraCertificatesToFingerprint = {
              # String above
              "NixOS cacert extra certificate string" =
                "A3:20:D0:84:96:97:25:FF:98:B8:A9:6D:A3:7C:89:95:6E:7A:77:21:92:F3:33:E9:31:AF:5E:03:CE:A9:E5:EE";

              # File
              "NixOS cacert extra certificate file" =
                "88:B8:BE:A7:57:AC:F1:FE:D6:98:8B:50:E0:BD:0A:AE:88:C7:DF:70:26:E1:67:5E:F5:F6:91:27:FF:02:D4:A5";
            };
            mapExtra = f: lib.concatStringsSep "\n" (lib.mapAttrsToList f extraCertificatesToFingerprint);
          in
          runCommand "verify-the-cacert-extra-output"
            {
              cacert = cacert.unbundled;
              cacertWithExtras =
                (cacert.override {
                  extraCertificateStrings = [ extraCertificateStr ];
                  extraCertificateFiles = [ extraCertificateFile ];
                }).unbundled;

              nativeBuildInputs = [ openssl ];
            }
            ''
              ${isTrusted}

              # Ensure that the extra certificate is not in the main "cacert".
              ${mapExtra (
                extraName: extraFingerprint: ''
                  isTrusted "$cacert" "${extraName}" "${extraFingerprint}" && ({
                    echo "'extra' CA fingerprint ${extraFingerprint} (${extraName}) is present in the main CA bundle." >&2
                    exit 1
                  })
                ''
              )}

              # Ensure that the extra certificates ARE in the "cacertWithExtras".
              ${mapExtra (
                extraName: extraFingerprint: ''
                  isTrusted "$cacertWithExtras" "${extraName}" "${extraFingerprint}" || ({
                    echo "CA fingerprint ${extraFingerprint} (${extraName}) is not present in the cacertWithExtras bundle." >&2
                    exit 1
                  })
                ''
              )}

              touch "$out"
            '';
      };
  };

  inherit meta;
}
