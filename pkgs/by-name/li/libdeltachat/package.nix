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
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdeltachat";
  version = "2.44.0";

  src = fetchFromGitHub {
    owner = "chatmail";
    repo = "core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GSmAU3xDwLvuy/A84/EBcHNLRAUz0f8s3pzjt81rkmQ=";
  };

  patches = [
    ./no-static-lib.patch
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    pname = "chatmail-core";
    inherit (finalAttrs) version src;
    hash = "sha256-AThOXZNy8nw6txTw0lsL85tScBzGa0r+IfThKp5ng40=";
  };

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  buildInputs = [
    openssl
    sqlcipher
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
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

  meta = {
    description = "Delta Chat Rust Core library";
    homepage = "https://github.com/chatmail/core";
    changelog = "https://github.com/chatmail/core/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.unix;
  };
})
