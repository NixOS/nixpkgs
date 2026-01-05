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

rustPlatform.buildRustPackage rec {
  pname = "cjdns";
  version = "22.1";

  src = fetchFromGitHub {
    owner = "cjdelisle";
    repo = "cjdns";
    tag = "cjdns-v${version}";
    hash = "sha256-0imQrkcvIA+2Eq/zlC65USMR7T3OUKwQxrB1KtVexyU=";
  };

  patches = [
    (replaceVars ./system-libsodium.patch {
      libsodium_include_dir = "${libsodium.dev}/include";
    })
    # Remove mkpasswd since it is failing the build
    (fetchpatch {
      url = "https://github.com/cjdelisle/cjdns/commit/6391dba3f5fdab45df4b4b6b71dbe9620286ce32.patch";
      hash = "sha256-XVA4tdTVMLrV6zuGoBCkOgQq6NXh0x7u8HgmaxFeoRI=";
    })
    (fetchpatch {
      url = "https://github.com/cjdelisle/cjdns/commit/436d9a9784bae85734992c2561c778fbd2f5ac32.patch";
      hash = "sha256-THcYNGVbMx/xf3/5UIxEhz3OlODE0qiYgDBOlHunhj8=";
    })
    # Fix build failure with Rust 1.89.0 (https://github.com/cjdelisle/cjdns/pull/1271)
    (fetchpatch {
      url = "https://github.com/cjdelisle/cjdns/commit/68b786aca5bfa427e5f58c029e4d9cc74969ef87.patch";
      hash = "sha256-FmrooDzrIWUIAnzwZTVDXI+Cl8pMngPqxsJjUHVhry8=";
    })
  ];

  cargoHash = "sha256-f96y6ZW0HxC+73ts5re8GIo2aigQgK3gXyF7fMrcJ0o=";

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
    changelog = "https://github.com/cjdelisle/cjdns/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
