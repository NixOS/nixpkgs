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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "openssl-projects";
    repo = "pkcs11-provider";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-rymH/0otZ553lKqfdTRR5ttNsom9A3ObNNxptqB/eno=";
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
    pkcs11ProviderPython3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    valgrind
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

  # Need to search $KRYOPTIC for the path to the actual Kryoptic library.
  postPatch = ''
    patchShebangs --build .
    substituteInPlace tests/kryoptic-init.sh \
      --replace-fail /usr/local/lib/kryoptic "\\''${KRYOPTIC}"
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

  # Tests bind to localhost.
  __darwinAllowLocalNetworking = true;

  doCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v(\\d+\\.\\d+\\.\\d+)"
    ];
  };

  meta = {
    homepage = "https://github.com/latchset/pkcs11-provider";
    description = "OpenSSL 3.x provider to access hardware or software tokens using the PKCS#11 Cryptographic Token Interface";
    maintainers = with lib.maintainers; [ numinit ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
}
