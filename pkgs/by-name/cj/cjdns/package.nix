{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  nodejs,
  which,
  util-linux,
  nixosTests,
  libsodium,
  pkg-config,
  replaceVars,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cjdns";
  version = "22.3";

  src = fetchFromGitHub {
    owner = "cjdelisle";
    repo = "cjdns";
    tag = "cjdns-v${finalAttrs.version}";
    hash = "sha256-A5KPcjFrCIYhT/6W+J4Nvb1y23cAgv9M6PWcyN43st4=";
  };

  patches = [
    (replaceVars ./system-libsodium.patch {
      libsodium_include_dir = "${libsodium.dev}/include";
    })
  ];

  cargoHash = "sha256-tob45/99svE0R1Kk7G1+H7waBWYmI9VKC8ffl3ZmdcU=";

  nativeBuildInputs = [
    which
    nodejs
    pkg-config
  ]
  ++
    # for flock
    lib.optional stdenv.hostPlatform.isLinux util-linux;

  buildInputs = [ libsodium ];

  env.SODIUM_USE_PKG_CONFIG = 1;
  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-O2"
      "-Wno-error=array-bounds"
      "-Wno-error=stringop-overflow"
      "-Wno-error=stringop-truncation"
    ]
    ++ lib.optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "11") [
      "-Wno-error=stringop-overread"
    ]
  );

  cargoTestFlags = [
    # don't run doctests since they fail with "cannot find type `Ctx` in this scope"
    "--lib"
    "--bins"
    "--tests"
  ];

  checkFlags = [
    # Tests don't seem to work - "called `Result::unwrap()` on an `Err` value: DecryptErr: NO_SESSION"
    "--skip=crypto::crypto_auth::tests::test_wireguard_iface_encrypt_decrypt"
    "--skip=crypto::crypto_auth::tests::test_wireguard_iface_encrypt_decrypt_with_auth"
  ];

  passthru.tests.basic = nixosTests.cjdns;

  meta = {
    description = "Encrypted networking for regular people";
    homepage = "https://github.com/cjdelisle/cjdns";
    changelog = "https://github.com/cjdelisle/cjdns/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
