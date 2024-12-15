{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  nodejs,
  which,
  python39,
  libuv,
  util-linux,
  nixosTests,
  libsodium,
  pkg-config,
  substituteAll,
}:

rustPlatform.buildRustPackage rec {
  pname = "cjdns";
  version = "21.4";

  src = fetchFromGitHub {
    owner = "cjdelisle";
    repo = "cjdns";
    rev = "cjdns-v${version}";
    sha256 = "sha256-vI3uHZwmbFqxGasKqgCl0PLEEO8RNEhwkn5ZA8K7bxU=";
  };

  patches = [
    (substituteAll {
      src = ./system-libsodium.patch;
      libsodium_include_dir = "${libsodium.dev}/include";
    })
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libsodium-sys-0.2.6" = "sha256-yr6wh0njbCFZViLROcqSSoRFj7ZAMYG5lo1g0j75SN0=";
    };
  };

  nativeBuildInputs =
    [
      which
      python39
      nodejs
      pkg-config
    ]
    ++
    # for flock
    lib.optional stdenv.hostPlatform.isLinux util-linux;

  buildInputs = [
    libuv
    libsodium
  ];

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

  passthru.tests.basic = nixosTests.cjdns;

  meta = with lib; {
    homepage = "https://github.com/cjdelisle/cjdns";
    description = "Encrypted networking for regular people";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux;
    broken = stdenv.hostPlatform.isAarch64;
  };
}
