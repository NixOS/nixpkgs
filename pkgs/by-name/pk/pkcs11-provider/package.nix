{ lib, stdenv, fetchFromGitHub
, openssl, nss, p11-kit
, opensc, gnutls, expect
, autoreconfHook, autoconf-archive, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "pkcs11-provider";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "pkcs11-provider";
    rev = "v${version}";
    hash = "sha256-jEQYsINRZ7bi2UqOXUUmGpm+1h+1qBNe18KvfAw2JzU=";
  };

  buildInputs = [ openssl nss p11-kit ];
  nativeBuildInputs = [ autoreconfHook pkg-config autoconf-archive ];

  # don't add SoftHSM to here: https://github.com/openssl/openssl/issues/22508
  nativeCheckInputs = [ p11-kit.bin opensc nss.tools gnutls openssl.bin expect ];

  postPatch = ''
    patchShebangs --build .

    # Makefile redirects to logfiles; make sure we can catch them.
    for name in softokn softhsm; do
      ln -s /dev/stderr tests/setup-$name.log
    done
  '';

  enableParallelBuilding = true;

  # Frequently fails due to a race condition.
  enableParallelInstalling = false;

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/latchset/pkcs11-provider";
    description = "An OpenSSL 3.x provider to access hardware or software tokens using the PKCS#11 Cryptographic Token Interface";
    maintainers = with maintainers; [ numinit ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
