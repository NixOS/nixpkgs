{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  cmake,
  deltachat-desktop,
  deltachat-repl,
  deltachat-rpc-server,
  openssl,
  perl,
  pkg-config,
  python3,
  rustPlatform,
  sqlcipher,
  sqlite,
  fixDarwinDylibNames,
  darwin,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "libdeltachat";
  version = "1.158.0";

  src = fetchFromGitHub {
    owner = "chatmail";
    repo = "core";
    tag = "v${version}";
    hash = "sha256-0po4nPCunq9cBaVFSsS1uo18dv6Y6IHGzL1zC2zwXdI=";
  };

  patches = [
    ./no-static-lib.patch
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    pname = "deltachat-core-rust";
    inherit version src;
    hash = "sha256-k8TN6YtCVPR8RnFoiGX9APvKwpQzj7T53DlKMD9r/e0=";
  };

  nativeBuildInputs =
    [
      cmake
      perl
      pkg-config
      rustPlatform.cargoSetupHook
      cargo
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      fixDarwinDylibNames
    ];

  buildInputs =
    [
      openssl
      sqlcipher
      sqlite
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
      libiconv
    ];

  nativeCheckInputs = with rustPlatform; [
    cargoCheckHook
  ];

  # Sometimes -fmacro-prefix-map= can redirect __FILE__ to non-existent
  # paths. This breaks packages like `python3.pkgs.deltachat`. We embed
  # absolute path to headers by expanding `__FILE__`.
  postInstall = ''
    substituteInPlace $out/include/deltachat.h \
      --replace __FILE__ '"${placeholder "out"}/include/deltachat.h"'
  '';

  env = {
    CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTarget;
    CARGO_BUILD_RUSTFLAGS = "-C linker=${stdenv.cc.targetPrefix}cc";
  };

  passthru = {
    tests = {
      inherit deltachat-desktop deltachat-repl deltachat-rpc-server;
      python = python3.pkgs.deltachat;
    };
  };

  meta = with lib; {
    description = "Delta Chat Rust Core library";
    homepage = "https://github.com/chatmail/core";
    changelog = "https://github.com/chatmail/core/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.unix;
  };
}
