{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  nss,
  p11-kit,
  opensc,
  softhsm,
  kryoptic,
  gnutls,
  expect,
  which,
  meson,
  ninja,
  pkg-config,
  valgrind,
  python3,
  nix-update-script,
}:

let
  pkcs11ProviderPython3 = python3.withPackages (pythonPkgs: with pythonPkgs; [ six ]);
in
stdenv.mkDerivation rec {
  pname = "pkcs11-provider";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "pkcs11-provider";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-QXEwDl6pk8G5ba8lD4uYw2QuD3qS/sgd1od8crHct2s=";
  };

  buildInputs = [
    openssl
    nss
    p11-kit
  ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    which
  ];

  nativeCheckInputs = [
    p11-kit.bin
    opensc
    kryoptic
    nss.tools
    gnutls
    openssl.bin
    expect
    valgrind
    pkcs11ProviderPython3
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    # softokn and kryoptic are OK; softhsm is pretty flaky.
    # This fails with a `pkcs11-provider:softhsm / tls - FAIL - exit status 1`.
    # Considering that kryoptic is the Rust replacement, we can rely on it instead:
    # https://github.com/softhsm/SoftHSMv2/issues/803
    softhsm
  ];

  env = {
    KRYOPTIC = "${lib.getLib kryoptic}/lib";
  };

  # Fix a typo in the Kryoptic test (remove this in v1.2).
  postPatch = ''
    patchShebangs --build .
    substituteInPlace tests/kryoptic-init.sh \
      --replace-fail /usr/local/lib/kryoptic "\\''${KRYOPTIC}" \
      --replace-fail "libkryoptic_pkcs11so" libkryoptic_pkcs11.so
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
    extraArgs = [
      "--version-regex"
      "v(\\d\\.\\d)"
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/latchset/pkcs11-provider";
    description = "OpenSSL 3.x provider to access hardware or software tokens using the PKCS#11 Cryptographic Token Interface";
    maintainers = with maintainers; [ numinit ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
