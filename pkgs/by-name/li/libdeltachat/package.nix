{ lib
, stdenv
, fetchFromGitHub
, cargo
, cmake
, deltachat-desktop
, deltachat-repl
, deltachat-rpc-server
, openssl
, perl
, pkg-config
, python3
, rustPlatform
, sqlcipher
, sqlite
, fixDarwinDylibNames
, darwin
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "libdeltachat";
  version = "1.151.6";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-core-rust";
    rev = "v${version}";
    hash = "sha256-alt4RkZeKz5yqbie3ksu9fKXKapYR0hCaY7vOMicrk8=";
  };

  patches = [
    ./no-static-lib.patch
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    pname = "deltachat-core-rust";
    inherit version src;
    hash = "sha256-++LG3MhmNVfHfMEuaSZrJYsf3NVbPWFD8KoDsiu9/Eg=";
  };

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  buildInputs = [
    openssl
    sqlcipher
    sqlite
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
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

  passthru = {
    tests = {
      inherit deltachat-desktop deltachat-repl deltachat-rpc-server;
      python = python3.pkgs.deltachat;
    };
  };

  meta = with lib; {
    description = "Delta Chat Rust Core library";
    homepage = "https://github.com/deltachat/deltachat-core-rust/";
    changelog = "https://github.com/deltachat/deltachat-core-rust/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.unix;
  };
}
