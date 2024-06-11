{ lib, stdenv, fetchFromGitHub
, openssl, nss, p11-kit
, opensc, gnutls, expect
, meson, ninja, pkg-config
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "pkcs11-provider";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "pkcs11-provider";
    rev = "v${version}";
    hash = "sha256-f4BbW2awSXS1srSkn1CTRCqNp+2pvVpc4YL79Ht0w0A=";
  };

  buildInputs = [ openssl nss p11-kit ];
  nativeBuildInputs = [ meson ninja pkg-config ];

  # don't add SoftHSM to here: https://github.com/openssl/openssl/issues/22508
  nativeCheckInputs = [ p11-kit.bin opensc nss.tools gnutls openssl.bin expect ];

  postPatch = ''
    patchShebangs --build .
  '';

  preInstall = ''
    # Meson tries to install to `$out/$out` and `$out/''${openssl.out}`; so join them.
    mkdir -p "$out"
    for dir in "$out" "${openssl.out}"; do
      mkdir -p .install/"$(dirname -- "$dir")"
      ln -s "$out" ".install/$dir"
    done
    export DESTDIR="$(realpath .install)"
  '';

  enableParallelBuilding = true;

  # Frequently fails due to a race condition.
  enableParallelInstalling = false;

  doCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex" "v(\d\.\d)"];
  };

  meta = with lib; {
    homepage = "https://github.com/latchset/pkcs11-provider";
    description = "OpenSSL 3.x provider to access hardware or software tokens using the PKCS#11 Cryptographic Token Interface";
    maintainers = with maintainers; [ numinit ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
