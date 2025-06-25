{ autoreconfHook
, boost
, coreutils
, curl
, cxx-rs
, db
, fetchFromGitHub
, fetchpatch
, git
, hexdump
, lib
, libevent
, libsodium
, llvmPackages
, makeWrapper
, overrideCC
, pkg-config
, rust
, rustPlatform
, stdenv
, testers
, tl-expected
, utf8cpp
, util-linux
, zcash
, zeromq
}:

let
  cpu = stdenv.targetPlatform.parsed.cpu.name;

  clangStdenv = if stdenv.isDarwin
    then llvmPackages.libcxxStdenv
    else overrideCC stdenv (llvmPackages.libcxxClang.override (old: {
      bintools = llvmPackages.bintools;

      nixSupport.cc-cflags = (old.nixSupport.cc-cflags or []) ++ [
        "-rtlib=compiler-rt"
        "-Wno-unused-command-line-argument"
      ];

      nixSupport.cc-ldflags = (old.nixSupport.cc-ldflags or []) ++ [
        "${llvmPackages.compiler-rt}/lib/linux/libclang_rt.builtins-${cpu}.a"
      ];

      nixSupport.libcxx-cxxflags = (old.nixSupport.libcxx-cxxflags or []) ++ [
        "-unwindlib=libunwind"
      ];

      # https://github.com/NixOS/nixpkgs/issues/201591
      nixSupport.libcxx-ldflags = (old.nixSupport.libcxx-ldflags or []) ++ [
        "-L${llvmPackages.libunwind}/lib"
        "-lunwind"
      ];
    }));

  boost' = (boost.override {
    stdenv = clangStdenv;
  }).overrideAttrs (old: {
    patches = old.patches ++ [
      (fetchpatch {
        url = "https://raw.githubusercontent.com/zcash/zcash/v6.10.0/depends/patches/boost/6753-signals2-function-fix.patch";
        stripLen = 0;
        sha256 = "sha256-LSmGZkswjbT1tDEKabGq/0e4UC6iJoo/8dJLOOHGGls=";
      })
    ];
  });

  db' = db.override { stdenv = clangStdenv; };
in
rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } rec {
  pname = "zcash";
  version = "6.10.0";

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "zcash";
    rev = "v${version}";
    hash = "sha256-Qe2eoRSgWSXvBRFV6Vg5R3QNDJfhdtYjxhZ6lkOH/FU=";
  };

  cargoLock = {
    lockFile = ./6.10.0-Cargo.lock;
  };

  nativeBuildInputs = [
    autoreconfHook
    cxx-rs
    git
    hexdump
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    boost'
    db'
    libevent
    libsodium
    tl-expected
    utf8cpp
    zeromq
  ];

  # Use the stdenv default phases (./configure; make) instead of the
  # ones from buildRustPackage.
  configurePhase = "configurePhase";
  buildPhase = "buildPhase";
  checkPhase = "checkPhase";
  installPhase = "installPhase";

  postPatch = ''
    # Have to do this here instead of in preConfigure because
    # cargoDepsCopy gets unset after postPatch.
    configureFlagsArray+=("RUST_VENDORED_SOURCES=$cargoDepsCopy")
  '';

  preConfigure = ''
    export CFLAGS="-pipe -O3 -Wno-unknown-warning-option"
    export CXXFLAGS="-pipe -O3 -Wno-unknown-warning-option -I${lib.getDev utf8cpp}/include/utf8cpp -I${lib.getDev cxx-rs}/include"
  '';

  hardeningEnable = [ ];
  dontDisableStatic = true;

  configureFlags = [
    "--disable-tests"
    "--disable-bench"
    "--with-boost-libdir=${lib.getLib boost'}/lib"
    "RUST_TARGET=${rust.toRustTargetSpec clangStdenv.hostPlatform}"
  ];

  enableParallelBuilding = true;

  # Requires hundreds of megabytes of zkSNARK parameters.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = zcash;
    command = "zcashd --version";
    version = "v${zcash.version}";
  };

  postInstall = ''
    wrapProgram $out/bin/zcash-fetch-params \
        --set PATH ${lib.makeBinPath [ coreutils curl util-linux ]}
  '';

  meta = with lib; {
    description = "Peer-to-peer, anonymous electronic cash system";
    homepage = "https://z.cash/";
    maintainers = with maintainers; [ rht tkerber centromere ];
    license = licenses.mit;

    # https://github.com/zcash/zcash/issues/4405
    broken = with clangStdenv.hostPlatform; isAarch64 && isDarwin;
  };
}
